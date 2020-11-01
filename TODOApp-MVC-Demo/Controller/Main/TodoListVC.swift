//
//  ViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class TodoListVC: UIViewController {
    // MARK:- Outlets and UI
    @IBOutlet weak var tableView: UITableView!
    fileprivate var newTaskButton       = UIButton()
    
    // MARK:- Properties
    fileprivate var tasks: [TaskData]   = []
    fileprivate var user: UserData!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        
        configureNavigation()
        configureNewTaskButton()
        configureTableView()
        fetshData()
        NotificationCenter.default.addObserver(self, selector: #selector(recivedNewTask(_:)), name: .didRecivedNewTask, object: nil)
    }
    
    @objc fileprivate func recivedNewTask(_ notification: Notification){
        guard let newTask = notification.userInfo?["newTask"] as? TaskData  else { return }
        tasks.append(newTask)
        tableView.reloadData()
    }
    
    fileprivate func configureNewTaskButton(){
        view.addSubview(newTaskButton)
        newTaskButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        newTaskButton.translatesAutoresizingMaskIntoConstraints = false
        newTaskButton.addTarget(self, action: #selector(newTaskPressed), for: .touchUpInside)
        newTaskButton.backgroundColor = UIColor.systemBlue
        newTaskButton.setTitle("New task", for: .normal)
        
        NSLayoutConstraint.activate([
            newTaskButton.heightAnchor.constraint(equalToConstant: 55),
            newTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            newTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    fileprivate func fetshData(){
        APIManager.getTasks { [weak self] (error, tasks) in
            guard let self = self else { return }
            if let error = error{
                print(error.localizedDescription)
            } else if let tasks = tasks{
                self.tasks = tasks.tasks
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    fileprivate func getUser() {
        APIManager.getUserInfo { [weak self] (error, user) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                self.user = user
            }
        }
    }
    
    fileprivate func configureNavigation(){
        title                   = "To Do"
        let profileIconConfig   = UIImage.SymbolConfiguration(pointSize: 33, weight: .medium, scale: .large)
        let profileIcon         = UIImage(systemName: "person.crop.circle", withConfiguration: profileIconConfig)
        let ProfileButton       = UIBarButtonItem(image: profileIcon, style: .done, target: self,
                                                  action: #selector(profilePressed))
        navigationItem.rightBarButtonItem = ProfileButton
    }
    
    fileprivate func configureTableView(){
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.separatorStyle    = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: newTaskButton.topAnchor)
        ])
    }
    
    @objc fileprivate func profilePressed(){
        let profileVC = ProfileVC.create()
        profileVC.user = user
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc fileprivate func newTaskPressed(){
        let newTaskVC = NewTaskVC.create()
        navigationController?.pushViewController(newTaskVC, animated: true)
    }

    // MARK:- Public Methods
    class func create() -> TodoListVC {
        let todoListVC: TodoListVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.todoListVC)
        return todoListVC
    }
}

extension TodoListVC: UITableViewDelegate, UITableViewDataSource, TaskCellDelegte {
    
    func deleteButtonPressed(_ task: TaskData, _ cell: TaskTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            APIManager.deleteTask(with: task) { (error, data) in
                // Need to refactor this complation
            }
        }
    }
    
    func statusButtonPressed(_ task: TaskData, _ cell: TaskTableViewCell) {
        if let indexPath    = tableView.indexPath(for: cell) {
            guard let cell  = self.tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return }
            let isDone = task.status ? false : true
            cell.setTaskStatus(isDone: isDone)
            tasks[indexPath.row].status = isDone
            var editedTask              = task
            editedTask.status           = isDone
            APIManager.editTask(with: editedTask) { (error, editedTask) in
               //May implment if success update tasks array then reload table
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.setCell(task: tasks[indexPath.row])
        cell.delegte = self
        return cell
    }
}
