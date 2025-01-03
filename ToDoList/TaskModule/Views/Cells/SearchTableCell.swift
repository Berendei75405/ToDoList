//
//  SearchTableCell.swift
//  ToDoList
//
//  Created by Novgorodcev on 27/12/2024.
//

import Foundation
import UIKit

final class SearchTableCell: UITableViewCell {
    
    static let identifier = "SearchTableCell"
    
    //MARK: - searchBar
    var searchBar: UISearchBar = {
        var bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.barStyle = .default
        bar.placeholder = "Search"
        bar.backgroundImage = UIImage()
        
        return bar
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    //MARK: - required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupUI
    private func setupUI() {
        contentView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            searchBar.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8),
            searchBar.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor)
        ])
    }

}
