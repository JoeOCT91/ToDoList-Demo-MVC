//
//  SignInVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
   //MARK:- Proprities
    
    fileprivate var email    = ""
    fileprivate var password = ""
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurTextFields()
        configureButtons()
        navigationController?.navigationBar.isHidden = true
        self.dimissKeyboardWhenTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func configurTextFields(){
        emailTextField.delegate                 = self
        passwordTextField.delegate              = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setShadows(textField: emailTextField)
        setShadows(textField: passwordTextField)
    }
    
    private func setShadows(textField: UITextField){
        // corner radius
        //textField.borderStyle = .none
        textField.layer.cornerRadius = 8

        // border
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.withAlphaComponent(0.5).cgColor

        // shadow
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 3)
        textField.layer.shadowOpacity = 0.7
        textField.layer.shadowRadius = 4.0
        
        textField.layer.shadowPath = UIBezierPath(roundedRect: textField.bounds, cornerRadius: 4).cgPath
        
        let paddingView : UIImageView = UIImageView(frame: .zero)
        let profileIconConfig   = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .large)
        
        paddingView.preferredSymbolConfiguration = profileIconConfig
        paddingView.image = (textField == emailTextField) ? UIImage(systemName: "envelope.circle") : UIImage(systemName: "lock.circle")
        
        paddingView.tintColor = .systemGray3
        paddingView.contentMode = .right
        
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        passwordLabel.text  = ""
        emailLabel.text     = ""
        
        if let text = textField.text, !text.isEmpty{
            if textField == passwordTextField {
                password = text
                passwordLabel.text = Validation.isPasswordValid(password) ?  "" : "Password is not valid"
            }
            if textField == emailTextField {
                email = text
                emailLabel.text = Validation.isValidEmail(email) ? "" : "Email is not valid"
            }
        }
        if Validation.isValidEmail(email) && Validation.isPasswordValid(password) {
            signInButton.isEnabled          = true
            signInButton.backgroundColor    = UIColor.systemBlue
        } else {
            signInButton.isEnabled          = false
            signInButton.backgroundColor    = UIColor.systemGray2
        }
    }
        
    private func configureButtons(){
        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        signInButton.clipsToBounds      = true
        signInButton.layer.cornerRadius = 8
        signInButton.isEnabled          = false
        signInButton.backgroundColor    = UIColor.systemGray2
    }
    
    @objc private func signInPressed(){
        if let text = emailTextField.text {
            email = text
        }
        if let text = passwordTextField.text {
            password = text
        }
        view.showLoader()
        APIManager.login(email: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case.success(let loginData):
                UserDefaultsManager.shared().token = loginData.token
                Authorization.authValue = "Bearer " + (UserDefaultsManager.shared().token ?? "")
                self.view.hideLoader()
                self.switchToMainState()
            case.failure(let error):
                self.view.hideLoader()
                self.presentError(with: error.localizedDescription)
            }
        }
    }

    private func presentError(with massage: String){
        self.showAlert(title: "Sorry", message: massage)
    }
    private func switchToMainState(){
        let toDoVC = TodoListVC.create()
        let navigationController = UINavigationController(rootViewController: toDoVC)
        AppDelegate.shared().window?.rootViewController = navigationController
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder() 
        passwordLabel.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()

    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
