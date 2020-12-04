//
//  SigninPresenter.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 11/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//
@objc protocol AuthPortocol: class {
    func switchToMainState()
    func enableButton()
    func disableButton()
    func showLoader()
    func hideLoader()
    func presentError(with massage: String)
    func setEmailErrorLabel(message: String)
    func setPasswordErrorLabel(message: String)
    @objc optional func setNameErrorLabel(message: String)
    @objc optional func setRePasswordErrorLabel(message: String)
    @objc optional func setAgeErrorLabel(message: String)
}

import Foundation

class AuthViewModel {
    //MARK:- Proprties
    weak private var delagte: AuthPortocol?
    weak var validator: ValidatorManager! =  ValidatorManager.shared()
    

    init(delagte: AuthPortocol?) {
        self.delagte = delagte
    }
    
    func loginCall(email: String, password: String){
        delagte?.showLoader()
        APIManager.login(email: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case.success(let loginData):
                UserDefaultsManager.shared().token = loginData.token
                Authorization.authValue = "Bearer " + (UserDefaultsManager.shared().token ?? "")
                self.delagte?.hideLoader()
                self.delagte?.switchToMainState()
            case.failure(let error):
                self.delagte?.hideLoader()
                self.delagte?.presentError(with: error.localizedDescription)
            }
        }
    }
    
    func signupCall(email: String, password: String, name: String, age: String){
        delagte?.showLoader()
        APIManager.signUP(with: name, email: email, password: password, age: age) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.delagte?.hideLoader()
            case .success(let loginData):
                UserDefaultsManager.shared().token = loginData.token
                self.delagte?.hideLoader()
                self.delagte?.switchToMainState()
            }
        }
    }
    
    func validSignInInputs(email: String, password: String){
        let emailIsValid = validEmail(email: email)
        let passwordIsValid = validPassword(password: password)
        if  emailIsValid && passwordIsValid {
            delagte?.enableButton()
        } else {
            delagte?.disableButton()
        }
    }
    
    func validSignUpInputs(name: String, email: String, password: String, age: String){
        let emailIsValid = validEmail(email: email)
        let passwordIsValid = validPassword(password: password)
        if validName(name: name) && emailIsValid && passwordIsValid {
            delagte?.enableButton()
        } else {
            delagte?.disableButton()
        }
    }
    
    private func validName(name: String) -> Bool{
        if name.isEmpty {
            delagte?.setNameErrorLabel!(message: "")
            return false
        }
        let tirmName = name.trimmed
        if tirmName.isEmpty {
            delagte?.setNameErrorLabel!(message: "Plase enter your Name")
            return false
        } else {
            delagte?.setNameErrorLabel!(message: "")
            return true
        }
    }
    
    private func validEmail(email: String) -> Bool{
        if email.isEmpty {
            delagte?.setEmailErrorLabel(message: "")
            return false
        }
        if validator.isValidEmail(email) {
            delagte?.setEmailErrorLabel(message: "")
            return true
        } else {
            delagte?.setEmailErrorLabel(message: "Please enter valid E-mail address")
            return false
        }
    }
    private func validPassword(password: String) -> Bool {
        if password.isEmpty {
            delagte?.setPasswordErrorLabel(message: "")
            return false
        }
        if validator.isPasswordValid(password){
            delagte?.setPasswordErrorLabel(message: "")
            return true
        } else {
            delagte?.setPasswordErrorLabel(message: "Please enter a valid password")
           return false
        }
    }
    
    private func validRePassword(password: String) -> Bool {
        if password.isEmpty {
            delagte?.setPasswordErrorLabel(message: "")
            return false
        }
        if validator.isPasswordValid(password){
            delagte?.setPasswordErrorLabel(message: "")
            return true
        } else {
            delagte?.setPasswordErrorLabel(message: "Please enter a valid password")
           return false
        }
    }
    private func validAge(password: String) -> Bool {
        if password.isEmpty {
            delagte?.setPasswordErrorLabel(message: "")
            return false
        }
        if validator.isPasswordValid(password){
            delagte?.setPasswordErrorLabel(message: "")
            return true
        } else {
            delagte?.setPasswordErrorLabel(message: "Please enter a valid password")
           return false
        }
    }
}
