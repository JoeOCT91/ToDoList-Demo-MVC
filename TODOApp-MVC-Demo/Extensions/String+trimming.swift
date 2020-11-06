//
//  String+trimming.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 04/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
