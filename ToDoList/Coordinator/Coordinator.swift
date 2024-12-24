//
//  Coordinator.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import UIKit

//MARK: - CoordinatorProtocol
protocol CoordinatorProtocol: AnyObject {
    func createTaskVC() -> UIViewController
    func initialTaskVC()
}

final class Coordinator: CoordinatorProtocol {
    var navController: UINavigationController?
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    //MARK: - createTaskVC
    func createTaskVC() -> UIViewController {
        let view = TaskViewController()
        let viewModel = TaskViewModel()

        view.viewModel = viewModel
        viewModel.coordinator = self
        
        return view
    }
    
    //MARK: - initialTaskVC
    func initialTaskVC() {
        if let navController = navController {
            let view = createTaskVC()
            
            navController.viewControllers = [view]
        }
    }
    
}
