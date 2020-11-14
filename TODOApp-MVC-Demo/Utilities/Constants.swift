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
    static let signUpVC         = "SignUpVC"
    static let signInVC         = "SignInVC"
    static let todoListVC       = "TodoListVC"
    static let newTaskVC        = "NewTaskVC"
    static let profileVC        = "ProfileVC"
    static let editTaskVc       = "EditTaskVC"
    static let editProfileVC    = "EditProfileVC"
}

// Urls
struct URLs {
    static let base     = "https://api-nodejs-todolist.herokuapp.com"
    static let user     = "/user"
    static let userInfo = "/user/me"
    static let login    = "/user/login"
    static let signup   = "/user/register"
    static let newTask  = "/task"
    static let upload   = base + "/user/me/avatar"
    static let editUser = "/user/me"
    
}

// Header Keys
struct HeaderKeys {
    static let contentType      = "Content-Type"
    static let authorization    = "Authorization"
}
// Authorization Key
struct Authorization {
    static var authValue = "Bearer " + (UserDefaultsManager.shared().token ?? "")
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
enum Colors: String {
    case blue = "blue"
    case gray = "gray"
}
