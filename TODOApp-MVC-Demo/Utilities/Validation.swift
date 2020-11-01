//
//  Va.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 01/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

class Validation {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    static func isPasswordValid(_ Password : String) -> Bool{
        let passwordRegEx =  "^[A-Za-z\\d$@$!%*?&]{8,32}"
        let PasswordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return PasswordPred.evaluate(with: Password)
    }
}
    

    



