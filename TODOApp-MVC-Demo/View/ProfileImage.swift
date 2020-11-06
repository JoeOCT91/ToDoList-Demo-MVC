//
//  ProfileImage.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 31/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ProfileImage: UIImageView {
    
    fileprivate let placeHolderImage = UIImage(named: "placeHolder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false

    }
}

