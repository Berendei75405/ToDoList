//
//  ViewController.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import UIKit
import Combine
import CoreData

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
                    viewModel?.fetchedResultsController?.delegate = self
                    tableView.reloadData()
                case .success:
                    tabBarCustom.configurate(task: viewModel?.numberOfTask(inSection: .zero) ?? 0)
                    viewModel?.fetchedResultsController?.delegate = self
                    tableView.reloadData()
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
        viewModel?.getTask()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute:  {
            self.viewModel?.removeEmptyTodo()
        })
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToView))
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
    
    //MARK: - handleTapToView
    @objc private func handleTapToView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

extension TaskViewController: UITableViewDelegate,
                              UITableViewDataSource,
                              TabBarCustomDelegate,
                              TaskTableCellProtocol,
                              UISearchBarDelegate,
                              NSFetchedResultsControllerDelegate  {
    //MARK: - tableViewDataSource
    //number of rows
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let todosCount = viewModel?.numberOfTask(
            inSection: section) ?? 0
        
        return todosCount
    }
    
    //configurate cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableCell.identifier, for: indexPath) as? TaskTableCell else { return UITableViewCell() }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let title = viewModel?.task(at: indexPath)?.title ?? ""
        let todo = viewModel?.task(at: indexPath)?.todo ?? ""
        let dateString = dateFormatter.string(from: viewModel?.task(at: indexPath)?.wasCreate ?? Date())
        let completed = viewModel?.task(at: indexPath)?.completed ?? false
        
        cell.config(title: title,
                    todo: todo,
                    dateString: dateString,
                    completed: completed,
                    indexPath: indexPath)
        
        cell.delegate = self
        
        return cell
    }
    
    //height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    //выбор ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.showDetail(indexPath: indexPath)
    }
    
    //создание контекстного меню
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            // Создаем три действия
            let action1 = UIAction(title: "Редактировать",
                                   image: UIImage(named: "editContext")) { [unowned self] _ in
                self.viewModel?.showDetail(indexPath: indexPath)
            }
            
            let action2 = UIAction(title: "Поделиться",
                                   image: UIImage(named: "export")) { [unowned self] _ in
                let items = [
                    viewModel?.task(at: indexPath)?.title ?? "",
                    viewModel?.task(at: indexPath)?.todo ?? ""]
                let actViewCon = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(actViewCon, animated: true)
            }
            
            let action3 = UIAction(title: "Удалить",
                                   image: UIImage(named: "trash")) { [unowned self] _ in
                self.viewModel?.removeTodo(at: indexPath)
            }
            
            // Объединяем их в одно меню
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [action1, action2, action3])
            
            return menu
        }
        
        return configuration
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
            viewModel?.removeTodo(at: indexPath)
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
        viewModel?.addTask()
    }
    
    //MARK: - TaskTableCellProtocol
    func completeChange(at indexPath: IndexPath) {
        viewModel?.changeTaskState(at: indexPath)
    }
    
    //MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        viewModel?.updateSearchFilter(searchText: searchText)
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            self.tabBarCustom.configurate(task: viewModel?.numberOfTask(inSection: indexPath.section) ?? .zero)
            tableView.reloadData()
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath],
                                 with: .left)
            self.tabBarCustom.configurate(task: viewModel?.numberOfTask(inSection: indexPath.section) ?? .zero)
        case .move:
            print("Move")
        case .update:
            guard let indexPath = indexPath else { return }
            self.tabBarCustom.configurate(task: viewModel?.numberOfTask(inSection: indexPath.section) ?? .zero)
            tableView.reloadData()
        default:
            print("Error state")
        }
    }
    
}
