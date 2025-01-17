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
        
        table.backgroundColor = .background
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
        
        let title = viewModel?.todo?.title ?? ""
        let dateString = viewModel?.todo?.dateString ?? ""
        let todo = viewModel?.todo?.todo ?? ""
        
        cell.config(title: title,
                    dateString: dateString,
                    todo: todo)
   
        cell.delegate = self
        
        return cell
    }
    
    //height cell
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let titleView = calculateTextHeight(
            text: viewModel?.todo?.title ?? "",
            font: .boldSystemFont(ofSize: 28))
        
        let todoView = calculateTextHeight(
            text: viewModel?.todo?.todo ?? "",
            font: .systemFont(ofSize: 18))
        
        let lab = calculateTextHeight(text: viewModel?.todo?.dateString ?? "", font: .systemFont(ofSize: 18))
        
        return titleView + todoView + lab
    }
    
    //DetailTableCellDelegate
    func heightWasChange(title: String, todo: String) {
        viewModel?.todo?.title = title
        viewModel?.todo?.todo = todo
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

}

