//
//  SignInVC.swift
//  TODOApp-MVC-Demo
//
//  Edited by Yousef Mohamed on 11/11/20.
//  Implmenting MVP
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit
protocol AuthNavigationDelgate: class {
    func showMainState()
    func showAuthState()
}

class SignInVC: UIViewController, signinDelgate {

    //MARK:- ViewModel Proprity
    private var viewModel: AuthViewModel!
    
    //MARK:- Outlets
    @IBOutlet var SingninView: SigninView!
    
    //MARK:- Cordinator
    weak var delgate: AuthNavigationDelgate?
    
   //MARK:- Proprities
    private var email    = ""
    private var password = ""
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SingninView.delgate = self
        SingninView.setup()
        navigationController?.navigationBar.isHidden = true
        dimissKeyboardWhenTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        password = SingninView.passwordTextField.text!
        email = SingninView.emailTextField.text!
        viewModel.validSignInInputs(email: email, password: password)
    }
    
    func presentError(with massage: String){
        self.showAlert(title: "Sorry", message: massage)
    }
 
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        let viewModel = AuthViewModel(delagte: signInVC)
        signInVC.viewModel = viewModel
        return signInVC
    }
}

extension SignInVC {
    
    @objc internal func signInPressed(){
        viewModel.loginCall(email: email, password: password)
    }
    
    @objc internal func signUpPressed(){
        let signUpVC = SignUpVC.create()
        signUpVC.delgate = self.delgate
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

extension SignInVC: AuthPortocol {
    
    func enableButton() {
        self.SingninView.signInButton.backgroundColor = .systemBlue
        self.SingninView.signInButton.isEnabled = true
    }
    func disableButton() {
        self.SingninView.signInButton.backgroundColor = .systemGray
        self.SingninView.signInButton.isEnabled = false
    }
    
    func switchToMainState(){
        self.delgate?.showMainState()
    }
    
    func setPasswordErrorLabel(message: String){
        SingninView.passwordLabel.text = message
    }
    
    func setEmailErrorLabel(message: String){
        SingninView.emailLabel.text = message
    }
    
    func showLoader() {
        self.view.showLoader()
    }

    func hideLoader() {
        self.view.hideLoader()
    }
}
