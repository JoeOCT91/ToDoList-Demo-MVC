//
//  g.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 06/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

extension UIButton {
    
    
//    func showLoader() {
//        let activityIndicator = setupActivityIndicator()
//        activityIndicator.startAnimating()
//        self.addSubview(activityIndicator)
//    }
//
//    func hideLoader() {
//        if let activityIndicator = viewWithTag(333) {
//            activityIndicator.removeFromSuperview()
//        }
//    }
    
    private func setupActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = self.bounds
        activityIndicator.center = self.center
        activityIndicator.style = .medium
        activityIndicator.tag = 333
        return activityIndicator
    }
}



