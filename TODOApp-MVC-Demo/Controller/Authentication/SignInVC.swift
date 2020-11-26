//
//  SignInVC.swift
//  TODOApp-MVC-Demo
//
//  Edited by Yousef Mohamed on 11/11/20.
//  Implmenting MVP
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, SignInViewPresenter, signinDelgate {
    
    //MARK:- Presenter Proprity
    private lazy var signInPresenter = SignInPresenter(signInViewDelgate: self)
    
    //MARK:- Outlets
    @IBOutlet var SingninView: SigninView!
    
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
    
    func enableSignInButton(isEnable: Bool, color: String){
        SingninView.signInButton.isEnabled = isEnable
        let colors: [String : UIColor] = [Colors.blue.rawValue : UIColor.systemBlue, Colors.gray.rawValue : UIColor.systemGray2]
        SingninView.signInButton.backgroundColor = colors[color]
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text{
            if textField == SingninView.passwordTextField { password = text }
            if textField == SingninView.emailTextField { email = text }
        }
        signInPresenter.validateInputs(with: email, password: password)
    }
    
    func setPasswordErrorLabel(message: String){
        SingninView.passwordLabel.text = message
    }
    
    func setEmailErrorLabel(message: String){
        SingninView.emailLabel.text = message
    }

    func presentError(with massage: String){
        self.showAlert(title: "Sorry", message: massage)
    }
    
    func presentLoader(isVisable: Bool){
        isVisable ? view.showLoader() : view.hideLoader()
    }
    
    func switchToMainState(){
        let toDoVC = TodoListVC.create()
        let navigationController = UINavigationController(rootViewController: toDoVC)
        AppDelegate.shared().window?.rootViewController = navigationController
    }
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        return signInVC
    }
}

extension SignInVC {
    
    @objc internal func signInPressed(){
        signInPresenter.loginCall(email: email, password: password)
    }
    
    @objc internal func signUpPressed(){
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}
