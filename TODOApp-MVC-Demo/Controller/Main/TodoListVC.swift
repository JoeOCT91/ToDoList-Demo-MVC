//
//  ViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class TodoListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var newTaskButton       = UIButton()
    var tasks: [TaskData]   = []

    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetshData()
        configureNavigation()
        configureTableView()
        configureNewTaskButton()
    }
    fileprivate func configureNewTaskButton(){
        view.addSubview(newTaskButton)
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
    fileprivate func configureNavigation(){
        let signoutButtun = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: #selector(signoutPressed))
        navigationItem.rightBarButtonItem = signoutButtun
        title = "To Do"
    }
    fileprivate func configureTableView(){
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.separatorStyle    = .none
    }
    @objc fileprivate func signoutPressed(){
        UserDefaultsManager.shared().token = nil
        let signInVC = SignInVC.create()
        navigationController?.pushViewController(signInVC, animated: true)
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
    func statusButtonPressed(_ task: TaskData, _ indexPath: IndexPath) {
        var editTask = task
        
        editTask.status = task.status ? false : true
        APIManager.editTask(with: editTask) {  (error, taskResponse) in
            //guard let self = self else { return }
            let cell = self.tableView.cellForRow(at: indexPath) as! TaskTableViewCell
            if let taskResponse = taskResponse  {
                cell.setCell(task: taskResponse.task, indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath)
            as! TaskTableViewCell
        cell.setCell(task: tasks[indexPath.row], indexPath: indexPath)
        cell.delegte = self
        return cell
    }
    

}
