//
//  EditTaskVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 02/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class EditTaskVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var saveButton = UIButton()
    var blur: UIVisualEffectView {
        let blur = UIBlurEffect(style: .dark)
        let vissualeffect = UIVisualEffectView(effect: blur)
        vissualeffect.frame = view.bounds
        vissualeffect.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        vissualeffect.alpha = 1
        return vissualeffect
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blur)
        view.sendSubviewToBack(blur)
        view.bringSubviewToFront(containerView)
        
        containerView.clipsToBounds         = true
        containerView.layer.cornerRadius    = 8
        containerView.addSubview(saveButton)
        saveButton.backgroundColor = .systemBlue
        saveButton.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 45),
                       saveButton.widthAnchor.constraint(equalToConstant: 45),

            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
           
            
            //saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        blur.addGestureRecognizer(tap)
    }
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

    
    
    // MARK:- Public Methods
    class func create() -> EditTaskVC {
        let editTaskVC: EditTaskVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.editTaskVc)
        return editTaskVC
    }

}
