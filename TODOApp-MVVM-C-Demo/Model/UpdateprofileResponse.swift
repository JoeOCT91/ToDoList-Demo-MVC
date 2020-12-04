//
//  UpdateprofileResponse.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 06/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct UpdateProfileResponse: Codable {
    
    var success: Bool
    var data: UserData
}
