//
//  TaskData.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 29/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct TaskData: Codable {
    
    var status: Bool
    var id: String
    var body: String
    
    enum CodingKeys: String, CodingKey  {
        case status = "completed"
        case id     = "_id"
        case body   = "description"
    }
}
