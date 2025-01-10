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
        table.register(DetailTableCell.self, forCellReuseIdentifier: DetailTableCell.identifier)
        
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
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //    //MARK: - activityView
    //    private var activityView: UIActivityIndicatorView = {
    //        var progres = UIActivityIndicatorView(style: .large)
    //        progres.translatesAutoresizingMaskIntoConstraints = false
    //        progres.startAnimating()
    //        progres.color = .black
    //        progres.isHidden = true
    //
    //        return progres
    //    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateState()
    }
    
    //MARK: - setupUI
    private func setupUI() {
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
    
}

extension DetailViewController: UITableViewDelegate,
                              UITableViewDataSource {
    //number of rows
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return .zero
    }
    
    //configurate cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableCell.identifier, for: indexPath) as? DetailTableCell else { return UITableViewCell() }
        
        return cell
    }
}
