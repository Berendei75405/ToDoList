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
                    tabBarCustom.configurate(task: viewModel?.task?.todos.count ?? 0)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //MARK: - searchBar
    var searchBar: UISearchBar = {
        var bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.barStyle = .default
        bar.placeholder = "Search"
        bar.backgroundImage = UIImage()
        
        return bar
    }()
    
    //MARK: - TabBarCustom
    private lazy var tabBarCustom: TabBarCustom = {
        let tab = TabBarCustom(frame: .init(x: .zero,
                                            y: .zero,
                                            width: view.frame.size.width,
                                            height: 49))
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.delegate = self
        
        return tab
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateState()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tabBarCustom.configurate(task: viewModel?.task?.todos.count ?? 0)
        viewModel?.getTask()
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
        tapGesture.cancelsTouchesInView = false
        let tapToView = UITapGestureRecognizer(target: self, action: #selector(handleTapToView))
        tableView.addGestureRecognizer(tapGesture)
        self.navigationController?.navigationBar.addGestureRecognizer(tapToView)
        
        //searchBar constraints
        searchBar.delegate = self
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        //tableView constraint
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor),
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
                              UITableViewDataSource,
                              TabBarCustomDelegate,
                              TaskTableCellProtocol,
                              UISearchBarDelegate {
    //number of rows
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let todosCount = viewModel?.filtredTask.count else { return 0}
        
        return todosCount
    }
    
    //configurate cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableCell.identifier, for: indexPath) as? TaskTableCell else { return UITableViewCell() }
        
        let rowIndex = indexPath.row
        let title = viewModel?.filtredTask[rowIndex].title ?? ""
        let todo = viewModel?.filtredTask[rowIndex].todo ?? ""
        let dateString = viewModel?.filtredTask[rowIndex].dateString ?? ""
        let completed = viewModel?.filtredTask[rowIndex].completed ?? false
        
        cell.config(title: title,
                    todo: todo,
                    dateString: dateString,
                    completed: completed,
                    index: rowIndex)
        
        cell.delegate = self
        cell.backgroundColor = UIColor(named: "backgroundColor")
        cell.selectionStyle = .none
        
        return cell
    }
    
    //height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    //выбор ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.showDetail(index: indexPath.row)
    }
    
    //создание контекстного меню
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            // Создаем три действия
            let action1 = UIAction(title: "Редактировать",
                                   image: UIImage(named: "editContext")) { [unowned self] _ in
                self.viewModel?.showDetail(index: indexPath.row)
            }
            
            let action2 = UIAction(title: "Поделиться",
                                   image: UIImage(named: "export")) { [unowned self] _ in
                let items = ["\(self.viewModel?.task?.todos[indexPath.row].title ?? "")", "\(self.viewModel?.task?.todos[indexPath.row].todo ?? "")"]
                let actViewCon = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(actViewCon, animated: true)
            }
            
            let action3 = UIAction(title: "Удалить",
                                   image: UIImage(named: "trash")) { [unowned self] _ in
                self.viewModel?.removeTodo(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                self.tabBarCustom.configurate(task: self.viewModel?.task?.todos.count ?? 0)
            }
            
            
            // Объединяем их в одно меню
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [action1, action2, action3])
            
            return menu
        }
        
        return indexPath.row != .zero ? configuration : nil
    }
    
    
    //возможность редактирования
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //чтобы выезжало справа меню
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //удаление ячеек через свайп влево
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.removeTodo(index: indexPath.row)
            tabBarCustom.configurate(task: viewModel?.task?.todos.count ?? 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - TabBarCustomDelegate
    func editMode() {
        viewModel?.editMode.toggle()
        tableView.setEditing(viewModel?.editMode ?? false, animated: true)
    }
    
    func addTask() {
        viewModel?.showDetail(index: nil)
    }
    
    //MARK: - TaskTableCellProtocol
    func completeChange(index: Int) {
        viewModel?.task?.todos[index].completed.toggle()
    }
    
    //MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        viewModel?.filtredTask = []
        var array: [IndexPath] = []
        if searchText == "" {
            viewModel?.createFiltredTask()
        }
        
        for todo in viewModel?.task?.todos ?? [] {
            if todo.title.uppercased().contains(searchText.uppercased()) {
                viewModel?.filtredTask.append(todo)
            }
        }
        
        for item in viewModel?.filtredTask ?? [] {
            array.append(IndexPath(row: item.id,
                                       section: .zero))
        }
        self.tableView.reloadData()
    }
    
}
