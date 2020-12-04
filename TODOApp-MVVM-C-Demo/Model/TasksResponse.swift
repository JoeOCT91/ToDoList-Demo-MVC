//
//  TasksResponse.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 30/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct TasksResponse: Codable {
    var count: Int?
    var tasks: [TaskData]
    
    enum CodingKeys: String, CodingKey {
        case count
        case tasks = "data"
    }
}
