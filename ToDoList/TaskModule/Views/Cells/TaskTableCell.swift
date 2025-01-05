//
//  TaskTableCell.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation
import UIKit

protocol TaskTableCellProtocol: AnyObject {
    func completeChange(index: Int)
}

final class TaskTableCell: UITableViewCell {
    
    static let identifier = "TaskTableCell"
    
    weak var delegate: TaskTableCellProtocol?
    
    private var completed = false
    var index: Int = 0
    
    //MARK: - titleLabel
    let titleLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = UIColor(named: "otherColor")
        lab.font = UIFont(name: "SF-Pro-Medium", size: 20)
        
        return lab
    }()
    
    //MARK: - toDoLabel
    let toDoLabel: UILabel = {
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
    
    let imageCircle = UIImage(named: "circle")
    let imageDone = UIImage(named: "done")
    
    //MARK: - doneButton
    lazy var doneButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    //Без этого будет некорректно работать зачеркивание!!!
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        toDoLabel.attributedText = nil
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
            delegate?.completeChange(index: index)
            titleLabel.attributedText = textToDefault(attributedText: titleLabel.attributedText)
            titleLabel.textColor = UIColor(named: "otherColor")
            toDoLabel.textColor = UIColor(named: "otherColor")
        } else {
            doneButton.setImage(imageDone,
                                for: .normal)
            delegate?.completeChange(index: index)
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            titleLabel.textColor = .gray
            toDoLabel.textColor = .gray
        }
        completed.toggle()
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
    private func textToDefault(attributedText: NSAttributedString?) -> NSAttributedString? {
        guard let aTxt = attributedText else { return nil }
        let mutableAttributedString = NSMutableAttributedString(attributedString: aTxt)
        mutableAttributedString.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: mutableAttributedString.length))
        
        return mutableAttributedString
    }
    
    //MARK: - config
    func config(title: String,
                todo: String,
                dateString: String,
                completed: Bool,
                index: Int) {
        
        self.titleLabel.text = title
        self.toDoLabel.text = todo
        self.dateLabel.text = dateString
        self.index = index
        self.completed = completed

        completed ? doneButton.setImage(imageDone, for: .normal) : doneButton.setImage(imageCircle, for: .normal)
        
        //состояние ячейки в зависимости от complete
        if completed {
            titleLabel.attributedText = NSAttributedString(string: title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            titleLabel.textColor = .gray
            toDoLabel.textColor = .gray
        } else {
            titleLabel.attributedText = textToDefault(attributedText: titleLabel.attributedText)
            titleLabel.textColor = .other
            toDoLabel.textColor = .other
        }
    }
}
