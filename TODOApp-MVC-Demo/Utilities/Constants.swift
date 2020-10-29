//
//  Constants.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation


// Storyboards
struct Storyboards {
    static let authentication = "Authentication"
    static let main = "Main"
}

// View Controllers
struct ViewControllers {
    static let signUpVC = "SignUpVC"
    static let signInVC = "SignInVC"
    static let todoListVC = "TodoListVC"
}

// Urls
struct URLs {
    static let base     = "https://api-nodejs-todolist.herokuapp.com/user"
    static let login    = base + "/login"
    static let signup   = base + "/register"
}

// Header Keys
struct HeaderKeys {
    static let contentType = "Content-Type"
}

// Parameters Keys
struct ParameterKeys {
    static let name     = "name"
    static let email    = "email"
    static let password = "password"
    static let age      = "age"
}

// UserDefaultsKeys
struct UserDefaultsKeys {
    static let token = "UDKToken"
}
