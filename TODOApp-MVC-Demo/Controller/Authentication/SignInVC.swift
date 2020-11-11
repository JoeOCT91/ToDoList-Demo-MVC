//
//  SignInVC.swift
//  TODOApp-MVC-Demo
//
//  Edited by Yousef Mohamed on 11/11/20.
//  Implmenting MVP
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, SignInViewDelegate {
    
    //MARK:- Presenter Proprity
    
    private let signInPresenter = SignInPresenter()
    
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
        signInPresenter.setUpSignInViewDelgate(signInViewDelgate: self)
        configurTextFields()
        configureButtons()
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
        signInButton.isEnabled = isEnable
        let colors: [String : UIColor] = ["blue" : UIColor.systemBlue, "gray" : UIColor.systemGray2]
        signInButton.backgroundColor = colors[color]
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text{
            if textField == passwordTextField { password = text }
            if textField == emailTextField { email = text }
        }
        signInPresenter.validateInputs(with: email, password: password)
    }
    
    func setPasswordErrorLabel(message: String){
        passwordLabel.text = message
    }
    
    func setEmailErrorLabel(message: String){
        emailLabel.text = message
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
    
    @objc private func signInPressed(){
        signInPresenter.loginCall(email: email, password: password)
    }
    
    @objc fileprivate func signUpPressed(){
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func configurTextFields(){
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setShadows(textField: emailTextField)
        setShadows(textField: passwordTextField)
    }
    
    private func configureButtons(){
        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        signInButton.clipsToBounds      = true
        signInButton.layer.cornerRadius = 8
        signInButton.isEnabled          = false
        signInButton.backgroundColor    = UIColor.systemGray2
    }
    
    private func setShadows(textField: UITextField){
        // corner radius
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
    
}
