//
//  DetailViewModel.swift
//  ToDoList
//
//  Created by Novgorodcev on 10/01/2025.
//

import Foundation
import Combine

protocol DetailViewModelProtocol: AnyObject {
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    var todo: Todo? {get set}
    func popToRoot()
}

final class DetailViewModel: DetailViewModelProtocol {
    var coordinator: CoordinatorProtocol!
    var updateTableState = PassthroughSubject<TableState, Never>()
    private var cancellabele = Set<AnyCancellable>()
    
    var todo: Todo?

    func popToRoot() {
        coordinator.popToRoot()
    }
}
