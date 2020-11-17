//
//  ToDolistPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 11/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

protocol ToDoListView: NSObject {
    func reloadData()
    func presentLoader(isVisable: Bool)
    func updateCellContent(task: TaskData, indexPath: IndexPath)
    func deleteRow(indexPath: IndexPath)
}

import Foundation

class ToDoListPresenter {
    
    weak private var toDoListView: ToDoListView?
    
    fileprivate var tasks: [TaskData]   = []
    

    init(toDoListView: ToDoListView?){
        self.toDoListView = toDoListView
        NotificationCenter.default.addObserver(self, selector: #selector(recivedNewTask(_:)), name: .didRecivedNewTask, object: nil)
    }
    
    @objc private func recivedNewTask(_ notification: Notification) {
        guard let newTask = notification.userInfo?["newTask"] as? TaskData  else { return }
        tasks.append(newTask)
        toDoListView?.reloadData()
    }
    
    func tasksCount() -> Int{
        return tasks.count
    }
    
    func getTask(taskIndex: Int) -> TaskData{
        return tasks[taskIndex]
    }
    
    func updateTaskStatus(taskIndex: Int, task: TaskData){
        let newStatus = task.status ? false : true
        print(newStatus)
        tasks[taskIndex].status = newStatus
        let indexPath = IndexPath(row: taskIndex, section: 0)
        toDoListView?.updateCellContent(task: tasks[taskIndex], indexPath: indexPath)
        let editedTask = tasks[taskIndex]
        APIManager.editTask(with: editedTask) { _ in }
    }
    
    func fetshData(){
        //toDoListDelgate?.presentLoader(isVisable: true)
        APIManager.getTasks { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.toDoListView?.presentLoader(isVisable: false)
            case .success(let tasksResponse):
                self.tasks = tasksResponse.tasks
                DispatchQueue.main.async {
                    self.toDoListView?.reloadData()
                    self.toDoListView?.presentLoader(isVisable: false)
                }
            }
        }
    }
    
    func delateTask(indexPath: IndexPath?){
        guard let indexPath = indexPath else { return }
        APIManager.deleteTask(with: tasks[indexPath.row]) { (result) in }
        self.tasks.remove(at: indexPath.row)
        toDoListView?.deleteRow(indexPath: indexPath)
    }
  
}
