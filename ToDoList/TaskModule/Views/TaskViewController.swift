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
    
    //MARK: - tableView
    private lazy var tableView: UITableView = {
        var table  = UITableView(frame: .zero, style: .plain)
        
        table.backgroundColor = UIColor(named: "backgroundColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .singleLine
        table.showsVerticalScrollIndicator = false
        
        //протоколы
        table.delegate = self
        table.dataSource = self
        
        //регистрация ячеек
        table.register(SearchTableCell.self, forCellReuseIdentifier: SearchTableCell.identifier)
        table.register(TaskTableCell.self, forCellReuseIdentifier: TaskTableCell.identifier)
        
        return table
    }()
    
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
                    self.tableView.reloadData()
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
    
    //MARK: - TabBarCustom
    private lazy var tabBarCustom: TabBarCustom = {
        let tab = TabBarCustom(frame: .init(x: .zero,
                                            y: .zero,
                                            width: view.frame.size.width,
                                            height: 49))
        tab.translatesAutoresizingMaskIntoConstraints = false
        
        return tab
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel?.getTask()
        updateState()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tabBarCustom.configurate(task: viewModel?.task?.todos.count ?? 0)
    }
    
    //MARK: - setupUI
    private func setupUI() {
        //заголовок
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Задачи"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "otherColor") as Any]
        navigationItem.standardAppearance = appearance
        
        //для клавиутуры
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let tapToView = UITapGestureRecognizer(target: self, action: #selector(handleTapToView))
        tableView.addGestureRecognizer(tapGesture)
        self.navigationController?.navigationBar.addGestureRecognizer(tapToView)
        
        //tableView constraint
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -80)
        ])
        
        //tabBarCustom constraints
        view.addSubview(tabBarCustom)
        NSLayoutConstraint.activate([
            tabBarCustom.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            tabBarCustom.heightAnchor.constraint(
                equalToConstant: 80),
            tabBarCustom.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            tabBarCustom.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: - updateState
    private func updateState() {
        viewModel?.updateTableState.sink(receiveValue: { [unowned self] state in
            self.tableState = state
        }).store(in: &cancellabele)
    }
    
    
    //MARK: - handleTap
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        // Получаем индекс пути ячейки, содержащей UISearchBar
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Проверка, что ячейка существует
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchTableCell else { return }
        
        // Проверяем, произошло ли касание вне рамки UISearchBar
        if !cell.searchBar.frame.contains(location) {
            self.view.endEditing(true)
        }
    }
    
    //MARK: - handleTapToView
    @objc private func handleTapToView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

extension TaskViewController: UITableViewDelegate,
                              UITableViewDataSource {
    //number of rows
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let todosCount = viewModel?.task?.todos.count else { return 0}
        
        return todosCount + 1
    }
    
    //configurate cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //первая ячейка поиск
        if indexPath.row == .zero {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.identifier, for: indexPath) as? SearchTableCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableCell.identifier, for: indexPath) as? TaskTableCell else { return UITableViewCell() }
            
            cell.config(title: viewModel?.task?.todos[indexPath.row - 1].title ?? "",
                        todo: viewModel?.task?.todos[indexPath.row - 1].todo ?? "",
                        dateString: viewModel?.task?.todos[indexPath.row - 1].dateString ?? "",
                        completed: viewModel?.task?.todos[indexPath.row - 1].completed ?? false)
            cell.backgroundColor = UIColor(named: "backgroundColor")
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    //height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == .zero {
            return 52
        } else {
            return 106            
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: indexPath.row as NSCopying, previewProvider: nil) { _ -> UIMenu? in
            // Создаем три действия
            let action1 = UIAction(title: "1") { _ in
                print("Нажата кнопка '1'")
            }
            
            let action2 = UIAction(title: "2") { _ in
                print("Нажата кнопка '2'")
            }
            
            let action3 = UIAction(title: "3") { _ in
                print("Нажата кнопка '3'")
            }
            
            // Объединяем их в одно меню
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [action1, action2, action3])
            
            return menu
        }
        
        return configuration
    }
}
