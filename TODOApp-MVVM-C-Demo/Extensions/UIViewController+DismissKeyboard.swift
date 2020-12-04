//
//  File.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 07/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

extension UIViewController {

    func dimissKeyboardWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
