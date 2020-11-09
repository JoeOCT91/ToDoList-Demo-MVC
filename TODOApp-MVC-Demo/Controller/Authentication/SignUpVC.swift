//
//  SignUpVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    // MARK:- Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    fileprivate var name        = String()
    fileprivate var email       = String()
    fileprivate var password    = String()
    fileprivate var age         = String()
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimissKeyboardWhenTap()
        configureTextFields()
        configureSignupButton()

    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    fileprivate func configureTextFields(){
//        nameTextField.delegate      = self
//        emailTextField.delegate     = self
//        passwordTextField.delegate  = self
//        ageTextField.delegate       = self
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            if textField == nameTextField {
                name = text
            }
            if textField ==  emailTextField {
                email = text
            }
            if textField == passwordTextField {
                password = text
            }
            if textField == ageTextField {
                age = text
            }
        }
    }
    private func configureSignupButton(){
        signUpButton.addTarget(self, action: #selector(signupPressed), for: .touchUpInside)
    }
    @objc private func signupPressed(){
        APIManager.signUP(with: name, email: email, password: password, age: age) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let loginData):
                UserDefaultsManager.shared().token = loginData.token
                let toDoListVC = TodoListVC.create()
                let navigationController = UINavigationController(rootViewController: toDoListVC)
                AppDelegate.shared().window?.rootViewController = navigationController
            }
        }
    }

    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        return signUpVC
    }
}

