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
        configureTextFields()
        configureSignupButton()

    }
    fileprivate func configureTextFields(){
        nameTextField.delegate      = self
        emailTextField.delegate     = self
        passwordTextField.delegate  = self
        ageTextField.delegate       = self
    }
    fileprivate func configureSignupButton(){
        signUpButton.addTarget(self, action: #selector(signupPressed), for: .touchUpInside)
    }
    @objc fileprivate func signupPressed(){
        print("pressed")
        APIManager.signup(with: name, email: email, password: password, age: age) { (error, loginData) in
            if let error = error {
                print(error.localizedDescription)
            } else if let loginData = loginData {
                print(loginData.token)
                let todoListVC = TodoListVC.create()
                self.navigationController?.pushViewController(todoListVC, animated: true)
            }
        }
    }

    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        return signUpVC
    }
}
extension SignUpVC: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty{
            if textField == nameTextField {
                name = text
            }
            if textField == emailTextField {
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
}
