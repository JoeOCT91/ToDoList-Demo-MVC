//
//  ToDolistPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 11/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

protocol ToDoListViewPresenter: NSObject {
    func reloadData()
    func presentLoader(isVisable: Bool)
    func updateCellContent(task: TaskData, indexPath: IndexPath)
}

import Foundation

class ToDoListPresenter {
    
    weak private var toDoListDelgate: ToDoListViewPresenter?
    
    fileprivate var tasks: [TaskData]   = []
    

    init(toDoListDelgate: ToDoListViewPresenter?){
        self.toDoListDelgate = toDoListDelgate
        NotificationCenter.default.addObserver(self, selector: #selector(recivedNewTask(_:)), name: .didRecivedNewTask, object: nil)
    }
    
    @objc private func recivedNewTask(_ notification: Notification) {
        guard let newTask = notification.userInfo?["newTask"] as? TaskData  else { return }
        tasks.append(newTask)
        toDoListDelgate?.reloadData()
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
        toDoListDelgate?.updateCellContent(task: tasks[taskIndex], indexPath: indexPath)
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
                self.toDoListDelgate?.presentLoader(isVisable: false)
            case .success(let tasksResponse):
                self.tasks = tasksResponse.tasks
                DispatchQueue.main.async {
                    self.toDoListDelgate?.reloadData()
                    self.toDoListDelgate?.presentLoader(isVisable: false)
                }
            }
        }
    }
    
    
    
}
