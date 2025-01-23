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
    
    func makeRequestArray<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        if shoudReturnError {
            return completion(.failure(.errorWithDescription("Ошибка")))
        } else {
            guard let data = data as? T else { return completion(.failure(.errorWithDescription("Ошибка"))) }
            return completion(.success(data))
        }
    }
    
}

//MARK: - MockNetworkManager
class MockNetworkManager: NetworkManagerProtocol {
    var networkService: NetworkServiceProtocol!
    var shoudReturnError = false
    var task = Task(todos: [])
    
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
    var shoudReturnError = false
    var taskToReturn = Task.init(todos: [])
    
    
    func fetchTask(task: Task) {
        
    }
    
    func removeTodo(index: Int) {
        taskToReturn.todos.remove(at: index)
    }
    
    func getTask() -> Task? {
        if shoudReturnError {
            return nil
        } else {
            return taskToReturn
        }
    }
    
    func editTodo(todo: Todo) {
        
    }
}

//MARK: - MockCoordinator
class MockCoordinator: CoordinatorProtocol {
    func showDetailVC(todo: Todo) {
        
    }
    
    func popToRoot() {
        
    }
}
