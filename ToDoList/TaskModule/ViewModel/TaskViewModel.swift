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
}

final class TaskViewModel: TaskViewModelProtocol {
    var coordinator: CoordinatorProtocol!
    private let networkManager = NetworkManager.shared
    var updateTableState = PassthroughSubject<TableState, Never>()
    
    private var cancellabele = Set<AnyCancellable>()
    
    
}
