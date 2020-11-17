//
//  SigninPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 11/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//
protocol SignInViewPresenter: NSObject {
    func switchToMainState()
    func presentLoader(isVisable: Bool)
    func presentError(with massage: String)
    func setEmailErrorLabel(message: String)
    func setPasswordErrorLabel(message: String)
    func enableSignInButton(isEnable: Bool, color: String)
}

import Foundation

class SignInPresenter {
    
    weak private var signInViewDelgate: SignInViewPresenter?
    
    var validator =  ValidatorManager.shared()
    
    init(signInViewDelgate: SignInViewPresenter?) {
        self.signInViewDelgate = signInViewDelgate
    }
    
    func setUpSignInViewDelgate(signInViewDelgate: SignInViewPresenter?){
        self.signInViewDelgate = signInViewDelgate
    }
    
    func validateInputs(with email: String, password: String){
        
        if validator.isValidEmail(email) || email.isEmpty {
            signInViewDelgate?.setEmailErrorLabel(message: "")
        } else {
            signInViewDelgate?.setEmailErrorLabel(message: "Invalid Email")
        }
        
        if validator.isPasswordValid(password) || password.isEmpty {
            signInViewDelgate?.setPasswordErrorLabel(message: "")
        } else {
            signInViewDelgate?.setPasswordErrorLabel(message: "Password must be 8 charcters")
        }
        
        if validator.isValidEmail(email) && validator.isPasswordValid(password){
            signInViewDelgate?.enableSignInButton(isEnable: true, color: "blue")
        } else {
            signInViewDelgate?.enableSignInButton(isEnable: false, color: "gray")
        }
    }
    
    func loginCall(email: String, password: String){
        signInViewDelgate?.presentLoader(isVisable: true)
        APIManager.login(email: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case.success(let loginData):
                UserDefaultsManager.shared().token = loginData.token
                Authorization.authValue = "Bearer " + (UserDefaultsManager.shared().token ?? "")
                self.signInViewDelgate?.presentLoader(isVisable: false)
                self.signInViewDelgate?.switchToMainState()
            case.failure(let error):
                self.signInViewDelgate?.presentLoader(isVisable: false)
                self.signInViewDelgate?.presentError(with: error.localizedDescription)
            }
        }
    }
    
    
    
}
