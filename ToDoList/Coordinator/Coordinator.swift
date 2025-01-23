//
//  Coordinator.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import UIKit

//MARK: - CoordinatorProtocol
protocol CoordinatorProtocol: AnyObject {
    func showDetailVC(todo: Todo)
    func popToRoot()
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
        let networkManager = NetworkManager()
        let networkService = NetworkService()
        let coreDataManager = CoreDataManager()

        view.viewModel = viewModel
        
        viewModel.coordinator = self
        viewModel.networkManager = networkManager
        viewModel.coreDataManager = coreDataManager
        
        networkManager.networkService = networkService
        
        return view
    }
    
    //MARK: - initialTaskVC
    func initialTaskVC() {
        if let navController = navController {
            let view = createTaskVC()
            
            navController.viewControllers = [view]
        }
    }
    
    //MARK: - createDetialVC
    func createDetialVC() -> UIViewController {
        let view = DetailViewController()
        let viewModel = DetailViewModel()
        let coreDataManager = CoreDataManager()
        
        view.viewModel = viewModel
        viewModel.coordinator = self
        viewModel.coreDataManager = coreDataManager
        
        return view
    }
    
    //MARK: - showDetailVC
    func showDetailVC(todo: Todo) {
        if let navController = navController {
            guard let vc = createDetialVC() as? DetailViewController else { return }
            vc.viewModel?.todo = todo
            
            navController.pushViewController(vc, animated: true)
        }
    }
    
    func popToRoot() {
        if let navController = navController {
            navController.navigationBar.prefersLargeTitles = true
            navController.popViewController(animated: true)
        }
    }
    
}
