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
    //fileprivate var tasks: [TaskData]   = []
    fileprivate var user: UserData!
    
    lazy private var toDoListPresenter = ToDoListPresenter(toDoListDelgate: self)
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        configureNavigation()
        configureNewTaskButton()
        configureTableView()
        fetshData()
    }

    
    private func configureNewTaskButton(){
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
        toDoListPresenter.fetshData()
    }
    
    private func getUser() {
        view.showLoader()
        APIManager.getUserInfo{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let userData):
                self.user = userData
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

extension TodoListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListPresenter.tasksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.setCell(task: toDoListPresenter.getTask(taskIndex: indexPath.row))
        cell.delegte = self
        return cell
    }
}

extension TodoListVC: ToDoListViewPresenter {
    
    func updateCellContent(task: TaskData, indexPath: IndexPath) {
        guard let cell  = self.tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return }
        cell.setCell(task: task)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func presentLoader(isVisable: Bool){
        isVisable ? view.showLoader() : view.hideLoader()
    }
    
}

extension TodoListVC: TaskCellDelegte {
    
    func statusButtonPressed(_ task: TaskData, _ cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        toDoListPresenter.updateTaskStatus(taskIndex: indexPath.row, task: task)
    }
    
    func editButtonPressed(_ task: TaskData, _ cell: TaskTableViewCell) {
        //        let editTaskVC = EditTaskVC.create()
        //        editTaskVC.modalPresentationStyle   = .overCurrentContext
        //        editTaskVC.modalTransitionStyle     = .crossDissolve
        //        //view.addSubview(blur)
        //        self.present(editTaskVC, animated: true)
    }
    
    func deleteButtonPressed(_ task: TaskData, _ cell: TaskTableViewCell) {
//        let deleteTaskAlert = UIAlertController(title: "Delete task", message: "Are you sure you want to delete This task",
//                                                preferredStyle: UIAlertController.Style.alert)
//        deleteTaskAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] (action: UIAlertAction!) in
//            guard let self = self else { return }
//            if let indexPath = self.tableView.indexPath(for: cell) {
//                self.tasks.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .left)
//                APIManager.deleteTask(with: task) { (result) in }
//            }
//        }))
//        deleteTaskAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(deleteTaskAlert, animated: true, completion: nil)
    }
    
}
