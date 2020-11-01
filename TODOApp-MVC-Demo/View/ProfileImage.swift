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
        self.contentMode        = .scaleAspectFill
        self.clipsToBounds      = true
        self.layer.cornerRadius = 8
        self.image              = placeHolderImage
    }
    func download (userID: String){
        APIManager.downloadAvtarImage(with: userID) { [weak self] (error, data) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let data = data else { return }
                print(data)
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async { self.image = image }
            }
        }
    }
}

