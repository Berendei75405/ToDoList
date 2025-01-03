//
//  TabBarCustom.swift
//  ToDoList
//
//  Created by Novgorodcev on 30/12/2024.
//

import UIKit

final class TabBarCustom: UIView {
    
    //MARK: - taskLabel
    private let taskLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = UIFont(name: "SFProText-Regular", size: 16)
        lab.textColor = UIColor(named: "otherColor")
        lab.textAlignment = .center
        
        return lab
    }()
    
    //MARK: - editButton
    private lazy var editButton: UIButton = {
        var button = UIButton()
        let image = UIImage(named: "edit")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image,
                        for: .normal)
        
        return button
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupUI
    private func setupUI() {
        backgroundColor = #colorLiteral(red: 0.2030287385, green: 0.2033452094, blue: 0.2129075825, alpha: 1)
        
        self.addSubview(taskLabel)
        NSLayoutConstraint.activate([
            taskLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            taskLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        self.addSubview(editButton)
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(
                equalTo: centerYAnchor, constant: -2),
            editButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            editButton.leadingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -74),
            editButton.heightAnchor.constraint(
                equalToConstant: 50)
        ])
    }
    
    //MARK: - configurate
    func configurate(task: Int) {
        taskLabel.text = "\(task) Задач"
    }
}
