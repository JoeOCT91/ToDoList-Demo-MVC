//
//  ProfilePictureTableViewCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 31/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ProfilePictureTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileImageCell"
    fileprivate var profileImage = ProfileImage(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureProfileImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func configureProfileImage(){
        contentView.addSubview(profileImage)
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 130),
            profileImage.widthAnchor.constraint(equalToConstant: 130),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 18),
            profileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -18),
            profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    func configure(userID: String){
        profileImage.download(userID: userID)
    }
}
