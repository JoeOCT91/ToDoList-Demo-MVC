//
//  UserData.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct UserData: Codable {
    
    var age: Int
    var id: String
    var name, email: String
    
    enum CodingKeys: String, CodingKey {
        case age, name, email
        case id = "_id"
    }
}
