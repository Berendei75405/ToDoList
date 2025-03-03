//
//  DetailTableCell.swift
//  ToDoList
//
//  Created by Novgorodcev on 11/01/2025.
//

import Foundation
import UIKit

protocol DetailTableCellDelegate: AnyObject {
    func heightWasChange(title: String,
                         todo: String)
}

final class DetailTableCell: UITableViewCell {
    
    static let identifier = "DetailTableCell"
    
    weak var delegate: DetailTableCellDelegate?
    
    //MARK: - titleView
    private lazy var titleView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .boldSystemFont(ofSize: 28)
        view.textColor = .other
        view.delegate = self
        view.isScrollEnabled = false
        view.becomeFirstResponder()
        
        return view
    }()
    
    //MARK: - dateLabel
    private let dateLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = .systemFont(ofSize: 18)
        lab.textColor = .gray
        
        return lab
    }()
    
    //MARK: - titleView
    private lazy var todoView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18)
        view.textColor = .other
        view.delegate = self
        view.isScrollEnabled = false
        
        return view
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
        self.selectionStyle = .none
        
        //titleView constraints
        contentView.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            titleView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8),
            titleView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8)
        ])
        
        //dateLabel constraints
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(
                equalTo: titleView.bottomAnchor),
            dateLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8),
            dateLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8)
        ])
        
        //todoView constraints
        contentView.addSubview(todoView)
        NSLayoutConstraint.activate([
            todoView.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor),
            todoView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8),
            todoView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8)
        ])
    }
    
    //MARK: - config
    func config(title: String,
                wasCreate: String,
                todo: String) {
        titleView.text = title
        dateLabel.text = wasCreate
        todoView.text = todo
    }
}

extension DetailTableCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.heightWasChange(title: titleView.text, todo: todoView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && textView == titleView {
            titleView.resignFirstResponder()
            todoView.becomeFirstResponder()
            
            return false
        }
        return true
    }
    
}

