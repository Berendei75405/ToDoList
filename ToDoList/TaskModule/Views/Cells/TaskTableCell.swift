//
//  TaskTableCell.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation
import UIKit

final class TaskTableCell: UITableViewCell {
    
    static let identifier = "TaskTableCell"
    
    //MARK: - titleLabel
    private var titleLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = UIColor(named: "otherColor")
        lab.font = UIFont(name: "SF-Pro-Medium", size: 20)
        
        return lab
    }()
    
    //MARK: - toDoLabel
    private let toDoLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = UIColor(named: "otherColor")
        lab.font = UIFont(name: "SFProText-Regular", size: 16)
        lab.numberOfLines = 2
        
        return lab
    }()
    
    //MARK: - dateLabel
    private let dateLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .gray
        lab.font = UIFont(name: "SFProText-Regular", size: 16)
        
        return lab
    }()
    
    var completed = false
    
    let imageCircle = UIImage(named: "circle")
    let imageDone = UIImage(named: "done")
    
    //MARK: - doneButton
    private lazy var doneButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        //doneButton constraints
        doneButton.addTarget(self,
                             action: #selector(doneButtonAction),
                             for: .touchUpInside)
        contentView.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: .zero),
            doneButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20),
            doneButton.widthAnchor.constraint(
                equalToConstant: 24),
            doneButton.heightAnchor.constraint(
                equalToConstant: 48),
        ])
        
        //titleLable constraints
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12),
            titleLabel.leadingAnchor.constraint(
                equalTo: doneButton.trailingAnchor,
                constant: 8),
            titleLabel.heightAnchor.constraint(
                equalToConstant: 22)
        ])
        
        //toDoLabel constraints
        contentView.addSubview(toDoLabel)
        NSLayoutConstraint.activate([
            toDoLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 6),
            toDoLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            toDoLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            
        ])
        
        //dateLabel constraints
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(
                equalTo: toDoLabel.bottomAnchor,
                constant: 6),
            dateLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor)
        ])
        
    }
    
    //MARK: - doneButtonAction
    @objc private func doneButtonAction() {
        if completed {
            doneButton.setImage(imageCircle,
                                for: .normal)
            completed = false
            titleLabel.attributedText = textToDefault(
                strike: titleLabel.text ?? "")
            titleLabel.textColor = UIColor(named: "otherColor")
            toDoLabel.textColor = UIColor(named: "otherColor")
            toDoLabel.attributedText = textToDefault(strike: toDoLabel.text ?? "")
        } else {
            doneButton.setImage(imageDone,
                                for: .normal)
            completed = true
            titleLabel.attributedText = strikeText(strike: titleLabel.text ?? "")
            titleLabel.textColor = .gray
            toDoLabel.textColor = .gray
        }
    }
    
    //MARK: - strikeText
    private func strikeText(strike : String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    //MARK: - textToDefault
    private func textToDefault(strike : String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))

        
        return attributeString
    }
    
    //MARK: - config
    func config(title: String,
                todo: String,
                dateString: String,
                completed: Bool) {
        
        titleLabel.text = title
        toDoLabel.text = todo
        dateLabel.text = dateString
        self.completed = completed
        
        completed ? doneButton.setImage(imageDone, for: .normal) : doneButton.setImage(imageCircle, for: .normal)
        
        if completed {
            titleLabel.attributedText = strikeText(strike: title)
            titleLabel.textColor = .gray
            toDoLabel.textColor = .gray
        }
    }
}
