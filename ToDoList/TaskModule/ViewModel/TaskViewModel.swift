//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation
import Combine

protocol TaskViewModelProtocol: AnyObject {
    var coordinator: CoordinatorProtocol! {get set}
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    var task: Task? {get set}
    var editMode: Bool {get set}
    func getTask()
    func removeTodo(index: Int)
    func showDetail(index: Int)
}

final class TaskViewModel: TaskViewModelProtocol {
    var coordinator: CoordinatorProtocol!
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    var updateTableState = PassthroughSubject<TableState, Never>()
    var task: Task?
    var editMode: Bool = false
    
    private var cancellabele = Set<AnyCancellable>()
    
    //MARK: - getTask
    func getTask() {
        networkManager.getTask { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let task):
                self.task = task
                self.coreDataManager.fetchTask(task: task)
                self.updateTableState.send(.success)
            case .failure(let error):
                self.updateTableState.send(.failure(error))
                print(error)
            }
        }
    }
    
    //MARK: - removeTodo
    func removeTodo(index: Int) {
        task?.todos.remove(at: index)
        coreDataManager.removeTodo(index: index)
    }
    
    //MARK: - showDetail
    func showDetail(index: Int) {
        guard let todo = task?.todos[index - 1] else { return }
        coordinator.showDetailVC(todo: todo)
    }
    
}
