//
//  EditProfileVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 05/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {
    
    //Mark:- Outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    //MARK:- Proprities
    private var blurVisualEffect: UIVisualEffectView {
        let blurBackground = UIBlurEffect(style: .systemMaterial)
        let blurVisualEffect = UIVisualEffectView(effect: blurBackground)
        blurVisualEffect.frame = view.bounds
        return blurVisualEffect
    }
    
    var userData: UserData!
    var complation : ((UserData) -> Void)?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        configureSaveButton()
        closeButtonConfigure()
        setTextFields()
        view.insertSubview(blurVisualEffect, at: 0)
    }
    private func configureContainerView() {
        containerView.clipsToBounds         = true
        containerView.layer.cornerRadius    = 8
        
    }
    private func setTextFields(){
        nameTextField.text  = userData.name
        emailTextField.text = userData.email
        ageTextField.text   = String(userData.age)
    }
    
    private func configureSaveButton(){
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        saveButton.clipsToBounds        = true
        saveButton.layer.cornerRadius   = 8
    }
    private func closeButtonConfigure(){
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        
    }
    @objc private func saveButtonPressed(){
        if let text = nameTextField.text {
            userData.name = text
        }
        if let text = emailTextField.text {
            userData.email = text
        }
        if let text =  ageTextField.text {
            userData.age = Int(text)!
            print(userData.age)
        }
        saveButton.showLoader()
        APIManager.updateUserProfile(with: userData) { (result) in
            switch result {
                case .success(let user):
                    self.complation?(user)
                    self.dismiss(animated: true, completion: nil)
                    return
                case.failure(let error):
                    return
            }
        }
        
    }
    @objc private func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }

    //MARK:- Public Methods
    class func create() -> EditProfileVC {
        let editProfileVC: EditProfileVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.editProfileVC)
        return editProfileVC
    }
}
