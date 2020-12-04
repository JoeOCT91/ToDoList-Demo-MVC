//
//  SingUpView.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 29/11/2020.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

@objc protocol SignUpDelgate {
    func signupPressed()
    func textFieldDidChange()
}

class SignUpView: UIView {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var rePasswordLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var delgate: SignUpDelgate?
    
    func setup(){
        setupSignUpButton()
        configureTextFields()
    }
    
    private func setupSignUpButton(){
        signUpButton.addTarget(delgate.self, action: #selector(delgate?.signupPressed), for: .touchUpInside)
        signUpButton.clipsToBounds      = true
        signUpButton.layer.cornerRadius = 8
        signUpButton.isEnabled          = false
        signUpButton.backgroundColor    = UIColor.systemGray2
    }
    private func configureTextFields(){
        nameTextField.addTarget(delgate.self, action: #selector(delgate?.textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(delgate.self, action: #selector(delgate?.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(delgate.self, action: #selector(delgate?.textFieldDidChange), for: .editingChanged)
        ageTextField.addTarget(delgate.self, action: #selector(delgate?.textFieldDidChange), for: .editingChanged)
    }
}
