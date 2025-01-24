//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation
import Combine

protocol TaskViewModelProtocol: AnyObject {
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    var task: Task? {get set}
    var filtredTask: [Todo] {get set}
    var editMode: Bool {get set}
    var networkManager: NetworkManagerProtocol! {get}
//    var coreDataManager: CoreDataManagerProtocol! {get set}
    func getTask()
    func removeTodo(index: Int)
    func showDetail(index: Int?)
    func createFiltredTask()
}

final class TaskViewModel: TaskViewModelProtocol {
    var coordinator: CoordinatorProtocol!
    var networkManager: NetworkManagerProtocol!
    var coreDataManager: CoreDataManagerProtocol!
    var updateTableState = PassthroughSubject<TableState, Never>()
    var task: Task? {
        didSet {
            createFiltredTask()
        }
    }
    var filtredTask: [Todo] = []
    var editMode: Bool = false
    
    private var cancellabele = Set<AnyCancellable>()
    
    //MARK: - getTask
    func getTask() {
        if coreDataManager.getTask() != nil {
            task = coreDataManager.getTask()
            self.updateTableState.send(.success)
        } else {
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
    }
    
    //MARK: - removeTodo
    func removeTodo(index: Int) {
        let newIndex = filtredTask[index].id
        coreDataManager.removeTodo(index: newIndex)
        task = coreDataManager.getTask()
    }
    
    //MARK: - showDetail
    func showDetail(index: Int?) {
        if index != nil {
            let todo = filtredTask[index!]
            coordinator.showDetailVC(todo: todo)
        } else {
            let indexNew = (task?.todos.count ?? 0) + 1
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            let formattedDateString = formatter.string(from: currentDate)
            
            let todo = Todo(id: indexNew, title: "Новая заметка", todo: "", completed: false, userID: Int.random(in: 0...100), dateString: formattedDateString)
            coreDataManager.editTodo(todo: todo)
            
            coordinator.showDetailVC(todo: todo)
        }
    }
    
    //MARK: - createFiltredTask
    func createFiltredTask() {
        self.filtredTask = []
        guard let todo = task?.todos else { return }
        filtredTask = todo.sorted {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy"
            let dateString1 = dateFormatter.date(from: $0.dateString) ?? Date()
            let dateString2 = dateFormatter.date(from: $1.dateString) ?? Date()
            return dateString1 > dateString2
        }
        
    }
    
}
