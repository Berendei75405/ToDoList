//
//  DetailViewModel.swift
//  ToDoList
//
//  Created by Novgorodcev on 10/01/2025.
//

import Foundation
import Combine
import CoreData

protocol DetailViewModelProtocol: AnyObject {
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    var coreDataManager: CoreDataManagerProtocol! {get set}
    var fetchedResultsController: NSFetchedResultsController<Todos>? { get set }
    func fetchTodo(id: Int)
    func saveChanges(title: String,
                     todo: String)
    func task(at indexPath: IndexPath) -> Todos?
    func popToRoot()
}

final class DetailViewModel: DetailViewModelProtocol {
    var coordinator: CoordinatorProtocol!
    var updateTableState = PassthroughSubject<TableState, Never>()
    private var cancellabele = Set<AnyCancellable>()
    var coreDataManager: CoreDataManagerProtocol!
    var fetchedResultsController: NSFetchedResultsController<Todos>?
    var id = 0
    
    //MARK: - fetchTodo
    func fetchTodo(id: Int) {
        self.id = id
        
        let fetchedRequest = Todos.fetchRequest()
        let predicate = NSPredicate(format: "id == %d",
                                    id)
        let sortDescriptor = NSSortDescriptor(key: "title",
                                              ascending: true)
        fetchedRequest.predicate = predicate
        fetchedRequest.sortDescriptors = [sortDescriptor]
        
        let mainContext = coreDataManager.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do {
            try fetchedResultsController?.performFetch()
            updateTableState.send(.success)
        } catch {
            print("Ошибка при выполнении запроса: $error)")
        }
    }
    
    //MARK: - taskForRowAt
    func task(at indexPath: IndexPath) -> Todos? {
        return fetchedResultsController?.object(at: indexPath)
    }
    
    //MARK: - saveChanges
    func saveChanges(title: String,
                     todo: String) {
        guard let todos = fetchedResultsController?.fetchedObjects?.first else { return }
        todos.title = title
        todos.todo = todo
        coreDataManager.saveChangesContext(contextIsView: true)
        updateTableState.send(.success)
    }
    
    //MARK: - popToRoot
    func popToRoot() {
        coordinator.popToRoot()
    }
    
}
