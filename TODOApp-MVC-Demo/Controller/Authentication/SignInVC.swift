//
//  SignInVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
   
    fileprivate var email    = ""
    fileprivate var password = ""
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurTextFields()
        configureButtons()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func configurTextFields(){
        emailTextField.delegate     = self
        passwordTextField.delegate  = self
    }
    
    fileprivate func configureButtons(){
        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
    }
    
    @objc fileprivate func signInPressed(){
        if let text = emailTextField.text {
            email = text
        }
        if let text = passwordTextField.text {
            password = text
        }
        //"youseftest@gmail.com" "12345678"
        APIManager.login(with: email, password: password) { (error, loginData) in
            if let error = error {
                print(error.localizedDescription)
            } else if let loginData = loginData {
                print(loginData.token)
                UserDefaultsManager.shared().token = loginData.token
            }
        }
    }
    
    @objc fileprivate func signUpPressed(){
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }


    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        return signInVC
    }

}
extension SignInVC: UITextFieldDelegate {
    
}
