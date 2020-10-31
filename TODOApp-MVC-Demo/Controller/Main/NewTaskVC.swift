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

        
    }
    fileprivate func configureSaveTaskButton() {
        saveTaskButton.addTarget(self, action: #selector(saveTaskPressed), for: .touchUpInside)
    }
    @objc fileprivate func saveTaskPressed(){
        let body = (taskBodyTextView.text ?? "")
        APIManager.SaveTask(with: body) { (error , newTaskResponse) in
            if let error = error {
                print(error.localizedDescription)
            } else if let newTaskResponse = newTaskResponse {
                print(newTaskResponse)
            }
        }  
    }
    
    // MARK:- Public Methods
    class func create() -> NewTaskVC {
        let newTaskVC: NewTaskVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.newTaskVC)
        return newTaskVC
    }


}
