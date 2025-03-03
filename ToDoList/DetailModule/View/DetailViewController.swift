//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Novgorodcev on 10/01/2025.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    var viewModel: DetailViewModelProtocol?
    
    private var centerYConstraint: NSLayoutConstraint!
    private var cancellabele = Set<AnyCancellable>()
    
    //MARK: - tableState
    private var tableState: TableState = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch tableState {
                case .initial:
                    tableView.reloadData()
                case .success:
                    tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //MARK: - tableView
    private lazy var tableView: UITableView = {
        var table  = UITableView(frame: .zero, style: .plain)
        
        table.backgroundColor = UIColor(named: "backgroundColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        
        //протоколы
        table.delegate = self
        table.dataSource = self
        
        //регистрация ячеек
        table.register(DetailTableCell.self,
                       forCellReuseIdentifier: DetailTableCell.identifier)
        
        return table
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - setupUI
    private func setupUI() {
        //nav button
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage,
                                             style: .plain,
                                             target: self,
                                         action: #selector(popToRoot))
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.standardAppearance = .none
        
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
                equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - updateState
    private func updateState() {
        viewModel?.updateTableState.sink(receiveValue: { [unowned self] state in
            self.tableState = state
        }).store(in: &cancellabele)
    }
    
    //MARK: - calculateTextHeight
    private func calculateTextHeight(text: String,
                                     font: UIFont) -> CGFloat {
        let txt = UITextView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: view.frame.width - 16,
                                           height: .greatestFiniteMagnitude))
        
        txt.font = font
        txt.text = text
        
        txt.sizeToFit()
        
        return txt.frame.height
    }
    
    //MARK: - popToRoot
    @objc private func popToRoot() {
        viewModel?.popToRoot()
    }
    
}

extension DetailViewController: UITableViewDelegate,
                                UITableViewDataSource,
                                DetailTableCellDelegate {

    //count of rows
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //configurate cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableCell.identifier, for: indexPath) as? DetailTableCell else { return UITableViewCell() }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let title = viewModel?.task(at: indexPath)?.title ?? ""
        let wasCreate = dateFormatter.string(from: viewModel?.task(at: indexPath)?.wasCreate ?? Date())
        let todo = viewModel?.task(at: indexPath)?.todo ?? ""
        
        cell.config(title: title,
                    wasCreate: wasCreate,
                    todo: todo)
   
        cell.delegate = self
        
        return cell
    }
    
    //height cell
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let titleView = calculateTextHeight(
            text: viewModel?.task(at: indexPath)?.title ?? "",
            font: .boldSystemFont(ofSize: 28))
        
        let todoView = calculateTextHeight(
            text: viewModel?.task(at: indexPath)?.todo ?? "",
            font: .systemFont(ofSize: 18))
        
        let lab = calculateTextHeight(text: dateFormatter.string(from: viewModel?.task(at: indexPath)?.wasCreate ?? Date()), font: .systemFont(ofSize: 18))
        
        return titleView + todoView + lab
    }
    
    //DetailTableCellDelegate
    func heightWasChange(title: String,
                         todo: String) {
        viewModel?.saveChanges(title: title,
                               todo: todo)
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

}

