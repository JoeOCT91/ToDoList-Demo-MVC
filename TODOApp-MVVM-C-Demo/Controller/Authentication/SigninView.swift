//
//  SigninView.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 22/11/2020.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

@objc protocol signinDelgate {
    func textFieldDidChange(_ textField: UITextField)
    func signUpPressed()
    func signInPressed()
}

class SigninView: UIView {

    //MARK:- Outlets
    
    var delgate: signinDelgate?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func setup(){
        setupTextField(emailTextField, "Email")
        setupTextField(passwordTextField, "Password",isSceure: true)
        setupSigninButton()
        setupsignUpButton()
    }
    //MARK:- Private Methods
    
    private func setupsignUpButton(){
        signUpButton.addTarget(delgate.self, action: #selector(delgate?.signUpPressed), for: .touchUpInside)
    }

    private func setupSigninButton(){
        signInButton.addTarget(delgate.self, action: #selector(delgate?.signInPressed), for: .touchUpInside)
        signInButton.clipsToBounds      = true
        signInButton.layer.cornerRadius = 8
        signInButton.isEnabled          = false
        signInButton.backgroundColor    = UIColor.systemGray2
    }
    
    private func setupTextField(_ textField: UITextField, _ placeHolder: String, isSceure: Bool = false){
        textField.addTarget(self.delgate, action: #selector(delgate?.textFieldDidChange(_:)), for: .editingChanged)
        textField.placeholder = placeHolder
        textField.isSecureTextEntry = isSceure
        setShadows(textField: textField)
    }
    
    private func setShadows(textField: UITextField){
        // corner radius
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white

        // border
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.withAlphaComponent(0.5).cgColor

        // shadow
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowOpacity = 0.7
        textField.layer.shadowRadius = 3.0
        
        textField.layer.shadowPath = UIBezierPath(roundedRect: textField.bounds, cornerRadius: 4).cgPath
        
        let paddingView : UIImageView = UIImageView(frame: .zero)
        let profileIconConfig   = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
        
        paddingView.preferredSymbolConfiguration = profileIconConfig
        paddingView.image = (textField == emailTextField) ? UIImage(systemName: "envelope.circle") : UIImage(systemName: "lock.circle")
        
        paddingView.tintColor = .systemGray3
        paddingView.contentMode = .center
        
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
    }

}
