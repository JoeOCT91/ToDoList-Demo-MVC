//
//  NewTaskResponse.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 30/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct NewTaskResponse: Codable {
    var success: Bool
    var task: TaskData
    
    enum CodingKeys: String, CodingKey {
        case success
        case task = "data"
    }
}
