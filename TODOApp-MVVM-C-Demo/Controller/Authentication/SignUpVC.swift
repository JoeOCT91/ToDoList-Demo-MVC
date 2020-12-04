//
//  SignUpVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, SignUpDelgate {


    func presentError(with massage: String) {
        
    }

    // MARK:- Outlets
    @IBOutlet var signUpView: SignUpView!

    
    private var viewModel: AuthViewModel!
    weak var delgate: AuthNavigationDelgate?

    
    private var name        = String()
    private var email       = String()
    private var password    = String()
    private var rePassword  = String()
    private var age         = String()
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimissKeyboardWhenTap()
        signUpView.delgate = self
        signUpView.setup()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    @objc func textFieldDidChange() {
        name = signUpView.nameTextField.text!
        email = signUpView.emailTextField.text!
        password =  signUpView.passwordTextField.text!
        age = signUpView.ageTextField.text!
        viewModel.validSignUpInputs(name: name, email: email, password: password, age: age)
    }

    @objc internal func signupPressed(){
        viewModel.signupCall(email: email, password: password, name: name, age: age)
    }
 

    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        let viewModel = AuthViewModel(delagte: signUpVC)
        signUpVC.viewModel = viewModel
        return signUpVC
    }
}

extension SignUpVC: AuthPortocol{
    func setNameErrorLabel(message: String) {
        self.signUpView.nameLabel.text = message
    }
    
    func setEmailErrorLabel(message: String) {
        self.signUpView.emailLabel.text = message
    }
    
    func setPasswordErrorLabel(message: String) {
        self.signUpView.passwordLabel.text = message
    }
    
    func setRePasswordErrorLabel(message: String) {
        self.signUpView.rePasswordLabel.text = message
    }
    
    func setAgeErrorLabel(message: String) {
        self.signUpView.ageLabel.text = message
    }
    
    func enableButton() {
        self.signUpView.signUpButton.backgroundColor = .systemBlue
        self.signUpView.signUpButton.isEnabled = true
    }
    func disableButton() {
        self.signUpView.signUpButton.backgroundColor = .systemGray
        self.signUpView.signUpButton.isEnabled = false
    }
    
    func enableSignUpButton() {
        self.signUpView.signUpButton.backgroundColor = .systemBlue
        self.signUpView.signUpButton.isEnabled = true
    }
    func disableSignUpButton() {
        self.signUpView.signUpButton.backgroundColor = .systemGray
        self.signUpView.signUpButton.isEnabled = false
    }
    
    func switchToMainState() {
        delgate?.showMainState()
    }
    
    func presentLoader(isVisable: Bool) {
        
    }
    
    func hideLoader() {
        self.view.hideLoader()
    }
    func showLoader() {
        self.view.showLoader()
    }
}
