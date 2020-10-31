//
//  TaskTableViewCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 30/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit
protocol TaskCellDelegte {
    func statusButtonPressed(_ task: TaskData, _ indexPath: IndexPath)
}

class TaskTableViewCell: UITableViewCell {
    
    static let identifier                   = "taskTableViewCell"
    var delegte: TaskCellDelegte?
    
    fileprivate var indexPath               = IndexPath()
    fileprivate var cellTask: TaskData!
    fileprivate var statusColor             = UIView()
    fileprivate var taskBodyLabel                       = UILabel()
    fileprivate var taskStatusButton        = UIButton()
    fileprivate var editTaskButton          = UIButton()
    fileprivate var deleteTaskButton        = UIButton()
    fileprivate let padding: CGFloat        = 8
    fileprivate let largeSF                 = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .default)
    fileprivate var statusSF                = "checkmark.square.fill"

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        configureContentView()
        configureTaskStatusButton()
        configureEditTaskButton()
        configureDeleteButton()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let contentViewFrame = self.contentView.frame
        let insetContentViewFrame = contentViewFrame.inset(by: UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8))
        self.contentView.frame = insetContentViewFrame
        self.selectedBackgroundView?.frame = insetContentViewFrame
    }
    @objc func statusButtonPressed(){
        delegte?.statusButtonPressed(cellTask, indexPath)
    }
    func setCell(task: TaskData, indexPath: IndexPath){
        cellTask = task
        self.indexPath = indexPath
        taskBodyLabel.text = task.body
        statusColor.backgroundColor = task.status ? .systemGreen : .systemRed
        statusSF = task.status ? "checkmark.square.fill" : "square"
        let largeBoldDoc = UIImage(systemName: statusSF, withConfiguration: largeSF)
        taskStatusButton.setImage(largeBoldDoc, for: .normal)
        taskStatusButton.tintColor = task.status ? .systemGreen : .systemRed
    }
    
    fileprivate func configureContentView(){
        self.contentView.layer.borderColor      = UIColor.systemGray3.cgColor
        self.contentView.layer.borderWidth      = 1.0
        self.contentView.layer.masksToBounds    = true
        self.contentView.layer.cornerRadius     = 8
    }
    
    fileprivate func addSubViews(){
        contentView.addSubview(taskBodyLabel)
        contentView.addSubview(taskStatusButton)
        contentView.addSubview(editTaskButton)
        contentView.addSubview(deleteTaskButton)
        contentView.addSubview(statusColor)
    }
    
    fileprivate func configure(){
        statusColor.backgroundColor = .systemRed
        
        taskBodyLabel.translatesAutoresizingMaskIntoConstraints     = false
        statusColor.translatesAutoresizingMaskIntoConstraints       = false
        
        taskBodyLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            statusColor.topAnchor.constraint(equalTo: contentView.topAnchor),
            statusColor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statusColor.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            statusColor.widthAnchor.constraint(equalToConstant: 12),
            
            taskBodyLabel.leadingAnchor.constraint(equalTo: statusColor.trailingAnchor, constant: 8),
            taskBodyLabel.trailingAnchor.constraint(equalTo: taskStatusButton.leadingAnchor, constant: -8),
            taskBodyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            taskBodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
    }
    fileprivate func configureTaskStatusButton() {
        taskStatusButton.translatesAutoresizingMaskIntoConstraints  = false
        let largeBoldDoc = UIImage(systemName: statusSF, withConfiguration: largeSF)
        taskStatusButton.setImage(largeBoldDoc, for: .normal)
        taskStatusButton.addTarget(self, action: #selector(statusButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            taskStatusButton.widthAnchor.constraint(equalToConstant: 32),
            taskStatusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            taskStatusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            taskStatusButton.bottomAnchor.constraint(equalTo: editTaskButton.topAnchor, constant: -padding),
        ])
    }
    fileprivate func configureEditTaskButton(){
        let largeBoldDoc = UIImage(systemName: "square.and.pencil", withConfiguration: largeSF)
        editTaskButton.setImage(largeBoldDoc, for: .normal)
        editTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editTaskButton.centerXAnchor.constraint(equalTo: taskStatusButton.centerXAnchor),
            editTaskButton.heightAnchor.constraint(equalTo: taskStatusButton.heightAnchor),
        ])
    }
    fileprivate func configureDeleteButton() {
        let largeBoldDoc = UIImage(systemName: "trash", withConfiguration: largeSF)
        deleteTaskButton.setImage(largeBoldDoc, for: .normal)
        deleteTaskButton.translatesAutoresizingMaskIntoConstraints  = false

        NSLayoutConstraint.activate([
            deleteTaskButton.heightAnchor.constraint(equalTo: taskStatusButton.heightAnchor),
            deleteTaskButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            deleteTaskButton.topAnchor.constraint(equalTo: editTaskButton.bottomAnchor, constant: padding),
            deleteTaskButton.centerXAnchor.constraint(equalTo: taskStatusButton.centerXAnchor)
        ])
    }

    
}
