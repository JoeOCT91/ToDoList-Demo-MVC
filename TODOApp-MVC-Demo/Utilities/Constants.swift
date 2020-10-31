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
    static let newTaskVC = "NewTaskVC"
}

// Urls
struct URLs {
    static let base     = "https://api-nodejs-todolist.herokuapp.com"
    static let login    = base + "/user/login"
    static let signup   = base + "/user/register"
    static let newTask  = base + "/task"
}

// Header Keys
struct HeaderKeys {
    static let contentType      = "Content-Type"
    static let authorization    = "Authorization"
}
// Authorization Key
struct Authorization {
    static let key = "Bearer " + (UserDefaultsManager.shared().token ?? "")
}

// Parameters Keys
struct ParameterKeys {
    static let name     = "name"
    static let email    = "email"
    static let password = "password"
    static let age      = "age"
    static let body     = "description"
}

// UserDefaultsKeys
struct UserDefaultsKeys {
    static let token = "UDKToken"
}
