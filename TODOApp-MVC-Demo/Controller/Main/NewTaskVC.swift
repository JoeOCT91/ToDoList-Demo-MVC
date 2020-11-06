//
//  NewTaskVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 30/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class NewTaskVC: UIViewController {

    @IBOutlet weak var saveTaskButton: UIButton!
    @IBOutlet weak var taskBodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSaveTaskButton()
        congigureTaskBodyTextView()
    }
    fileprivate func congigureTaskBodyTextView(){
        taskBodyTextView.clipsToBounds      = true
        taskBodyTextView.layer.cornerRadius = 8
        taskBodyTextView.layer.borderWidth  = 1
        taskBodyTextView.layer.borderColor  = UIColor.systemGray3.cgColor
    }
    fileprivate func configureSaveTaskButton() {
        saveTaskButton.addTarget(self, action: #selector(saveTaskPressed), for: .touchUpInside)
        saveTaskButton.clipsToBounds = true
        saveTaskButton.layer.cornerRadius = 8
    }
    @objc fileprivate func saveTaskPressed(){
        let body = (taskBodyTextView.text ?? "")
        APIManager.SaveTask(with: body) { [weak self] (error , newTaskResponse) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else if let newTaskResponse = newTaskResponse {
                let newtask: [String : TaskData] = ["newTask" : newTaskResponse.task]
                NotificationCenter.default.post(name: .didRecivedNewTask, object: nil, userInfo: newtask)
                self.navigationController?.popViewController(animated: true)
            }
        }  
    }
    
    // MARK:- Public Methods
    class func create() -> NewTaskVC {
        let newTaskVC: NewTaskVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.newTaskVC)
        return newTaskVC
    }


}
