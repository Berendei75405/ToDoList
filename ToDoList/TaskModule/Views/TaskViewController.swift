//
//  ViewController.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import UIKit
import Combine

final class TaskViewController: UIViewController {
    
    var viewModel: TaskViewModelProtocol?
    
    private var centerYConstraint: NSLayoutConstraint!
    private var cancellabele = Set<AnyCancellable>()
    
    //MARK: - tableState
    private var tableState: TableState = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch tableState {
                case .initial:
                    print("Initial")
                case .success:
//                    activityView.isHidden = true
//                    UIView.animate(withDuration: 0.8,
//                                   delay: 0,
//                                   options: .curveEaseInOut,
//                                   animations: {
//                        self.centerYConstraint.constant = self.view.frame.height * 2
//                        self.view.layoutIfNeeded()
//                    })
//                    self.viewModel?.coordinator.showGistVC(
//                        user: viewModel?.gistInfo ?? [], userName: viewModel?.userName ?? "Пользователь")
                    print("1")
                case .failure(let error):
//                    if viewModel?.error == nil {
//                        viewModel?.error = error
//                        activityView.isHidden = true
//                        UIView.animate(withDuration: 0.8,
//                                       delay: 0,
//                                       options: .curveEaseInOut,
//                                       animations: {
//                            self.centerYConstraint.constant = 0
//                            self.view.layoutIfNeeded()
//                        })
//                    } else {
//                        viewModel?.error = nil
//                        activityView.isHidden = true
//                        UIView.animate(withDuration: 0.8,
//                                       delay: 0,
//                                       options: .curveEaseInOut,
//                                       animations: {
//                            self.centerYConstraint.constant = self.view.frame.height * 2
//                            self.view.layoutIfNeeded()
//                        })
//                    }
//                    switch error {
//                    case .errorWithDescription(let string):
//                        errorView.configurate(textError: string)
//                    case .error(let error):
//                        errorView.configurate(textError: error.localizedDescription)
//                    }
                    print("1")
                }
            }
        }
    }
    
    //MARK: - activityView
    private var activityView: UIActivityIndicatorView = {
        var progres = UIActivityIndicatorView(style: .large)
        progres.translatesAutoresizingMaskIntoConstraints = false
        progres.startAnimating()
        progres.color = .black
        progres.isHidden = true
        
        return progres
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    
    
}


