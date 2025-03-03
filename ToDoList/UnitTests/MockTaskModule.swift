//
//  MockTaskModule.swift
//  ToDoList
//
//  Created by Novgorodcev on 20/01/2025.
//

import Foundation
import Combine
import CoreData

//MARK: - MockNetworkService
class MockNetworkService: NetworkServiceProtocol {
    var shoudReturnError = false
    var data = Data()
    var error = NetworkError.errorWithDescription("")
    
    func makeRequestArray<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        if shoudReturnError {
            return completion(.failure(.errorWithDescription("Ошибка")))
        } else {
            guard let data = data as? T else { return completion(.failure(error)) }
            return completion(.success(data))
        }
    }
    
}

//MARK: - MockNetworkManager
class MockNetworkManager: NetworkManagerProtocol {
    var networkService: NetworkServiceProtocol!
    var shoudReturnError = false
    var task: Task!
    var error = NetworkError.errorWithDescription("")
    
    func getTask(completion: @escaping (Result<Task, NetworkError>) -> Void) {
        if shoudReturnError {
            return completion(.failure(.errorWithDescription("Error")))
        } else {
            return completion(.success(task))
        }
    }
}

//MARK: - MockCoreDataManager
class MockCoreDataManager: CoreDataManagerProtocol {
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { description, error in
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    func fetchTask(task: Task) {
        //проверка нет ли записей
        let request = TaskModel.fetchRequest()
        guard let count = try? persistentContainer.viewContext.count(for: request) else { return }
        
        if count == .zero {
            //создание задач
            let taskCoreData = TaskModel(context: persistentContainer.viewContext)
            
            for item in task.todos {
                let todo = Todos(context: persistentContainer.viewContext)
                todo.title = item.title
                todo.todo = item.todo
                todo.wasCreate = item.wasCreate
                todo.completed = item.completed
                todo.id = Int16(item.id)
                todo.userID = Int16(item.userID)
                
                //указываем связывание!
                taskCoreData.addToTodos(todo)
            }
            self.saveChangesContext(contextIsView: true)
        }
    }
    
    func taskIsEmpty() -> Bool {
        let request = Todos.fetchRequest()
        let todos = try? persistentContainer.viewContext.fetch(request)
        
        return todos?.count == 0 || todos == nil
    }
    
    func saveChangesContext(contextIsView: Bool) {
        let context = contextIsView ? persistentContainer.viewContext : persistentContainer.newBackgroundContext()
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func addTodos(newIndex: Int) {
        
    }
   
}

//MARK: - MockCoordinator
class MockCoordinator: CoordinatorProtocol {
    
    func showDetailVC(id: Int) {
        
    }
    
    func showDetailVC(todo: Todo) {
        
    }
    
    func popToRoot() {
        
    }
}
