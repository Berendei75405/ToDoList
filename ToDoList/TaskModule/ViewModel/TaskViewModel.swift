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
    func getTask()
    var task: Task? {get set}
}

final class TaskViewModel: TaskViewModelProtocol {
    var coordinator: CoordinatorProtocol!
    private let networkManager = NetworkManager.shared
    var updateTableState = PassthroughSubject<TableState, Never>()
    var task: Task?
    
    private var cancellabele = Set<AnyCancellable>()
    
    //MARK: - getTask
    func getTask() {
        networkManager.getTask { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let task):
                self.task = task
                self.updateTableState.send(.success)
            case .failure(let error):
                self.updateTableState.send(.failure(error))
                print(error)
            }
        }
    }
    
}
