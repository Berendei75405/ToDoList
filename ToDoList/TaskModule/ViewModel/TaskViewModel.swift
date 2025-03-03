//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation
import Combine
import CoreData

protocol TaskViewModelProtocol: AnyObject {
    var updateTableState: PassthroughSubject<TableState, Never> { get set }
    var editMode: Bool { get set }
    var networkManager: NetworkManagerProtocol! { get }
    var coreDataManager: CoreDataManagerProtocol! { get set }
    var fetchedResultsController: NSFetchedResultsController<Todos>? { get set }
    func getTask()
    func removeTodo(at indexPath: IndexPath)
    func changeTaskState(at indexPath: IndexPath)
    func updateSearchFilter(searchText: String)
    func showDetail(indexPath: IndexPath)
    func numberOfTask(inSection section: Int) -> Int
    func task(at indexPath: IndexPath) -> Todos?
    func addTask()
    func removeEmptyTodo()
}

final class TaskViewModel: TaskViewModelProtocol {
    var coordinator: CoordinatorProtocol!
    var networkManager: NetworkManagerProtocol!
    var coreDataManager: CoreDataManagerProtocol!
    var updateTableState = PassthroughSubject<TableState, Never>()
    private var cancellabele = Set<AnyCancellable>()
    var editMode: Bool = false
    var fetchedResultsController: NSFetchedResultsController<Todos>?
    
    //MARK: - getTask
    func getTask() {
        if coreDataManager.taskIsEmpty() == true {
            networkManager.getTask { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let task):
                    self.coreDataManager.fetchTask(task: task)
                    initialFetchResult()
                    self.updateTableState.send(.success)
                case .failure(let error):
                    self.updateTableState.send(.failure(error))
                    print(error)
                }
            }
        } else {
            initialFetchResult()
            updateTableState.send(.success)
        }
    }
    
    //MARK: - initialFetchResult
    private func initialFetchResult() {
        let fetchRequest = Todos.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "wasCreate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let persistentContainer = coreDataManager.persistentContainer
        let mainContext = persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Ошибка при выполнении Fetch Request: $error)")
        }
    }
    
    //MARK: - numberOfTask
    func numberOfTask(inSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    //MARK: - taskForRowAt
    func task(at indexPath: IndexPath) -> Todos? {
        return fetchedResultsController?.object(at: indexPath)
    }
    
    //MARK: - removeTodo
    func removeTodo(at indexPath: IndexPath) {
        guard let object = fetchedResultsController?.object(at: indexPath) else { return }
        guard let arrayTodos = fetchedResultsController?.fetchedObjects else { return }
        fetchedResultsController?.managedObjectContext.delete(object)
        
        //правим индексы других файлов
        for todo in arrayTodos {
            if todo.id > object.id {
                todo.id -= 1
            }
        }
        
        //сохраняем изменения
        coreDataManager.saveChangesContext(contextIsView: true)
    }
    
    //MARK: - changeTaskState
    func changeTaskState(at indexPath: IndexPath) {
        guard let todo = fetchedResultsController?.object(at: indexPath) else { return }
        todo.completed.toggle()
        
        coreDataManager.saveChangesContext(contextIsView: true)
    }
    
    //MARK: - updateSearchFilter
    func updateSearchFilter(searchText: String) {
        //обновляем запрос с учетом фильтра
        let fetchedRequest = Todos.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title",
                                              ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptor]
        
        if !searchText.isEmpty {
            //добавляем предикат для фильтрации
            fetchedRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
        }
        
        //создаем новый NSFethedResultController c обновленным запросом
        let mainContext = coreDataManager.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: mainContext, sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
            updateTableState.send(.initial)
        } catch {
            print("Ошибка при выполнении запроса: $error)")
        }
    }
    
    //MARK: - showDetail
    func showDetail(indexPath: IndexPath) {
        guard let object = fetchedResultsController?.object(at: indexPath) else { return }
        let id = Int(object.id)
        coordinator.showDetailVC(id: id)
    }
    
    //MARK: - addTask
    func addTask() {
        let newIndex = (fetchedResultsController?.fetchedObjects?.count ?? .zero) + 1
        coreDataManager.addTodos(newIndex: newIndex)
        coordinator.showDetailVC(id: newIndex)
    }
    
    //MARK: - removeEmptyTodo
    func removeEmptyTodo() {
        guard let objects = fetchedResultsController?.fetchedObjects else { return }
        
        //ищем пустые заметки
        for item in objects {
            if item.title?.isEmpty == true && item.todo?.isEmpty == true {
                fetchedResultsController?.managedObjectContext.delete(item)
                coreDataManager.saveChangesContext(contextIsView: true)
            }
        }
    }
    
}
