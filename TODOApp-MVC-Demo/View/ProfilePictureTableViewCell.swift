//
//  ProfilePictureTableViewCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 31/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit
protocol EditProfileDelgate: class {
    func editProfilePressed(_ cell: ProfilePictureTableViewCell)

}

class ProfilePictureTableViewCell: UITableViewCell {
    
    weak var delgate: EditProfileDelgate?
    
    
    //MARK:- Proprities
    static let identifier       = "ProfileImageCell"
    private var profileImage    = UIImageView(frame: .zero)
    private var label           = UILabel()
    private var uploadButton    = UIButton()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        subViews()
        configureProfileImage()
        configureLabel()
        configureUploadButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //Mark:- Public Methods
    func configure(userID: String, name: String){
        setLabelText(name: name)
        self.download(userID: userID)
    }
    func setProfileImage(image: UIImage){
        profileImage.image = image
        label.removeFromSuperview()
    }

    //Mark:- Private Methods
    private func setLabelText(name: String){
        let stringInput = name
        let stringToArr = stringInput.components(separatedBy:" ")
        var finalString = ""
        if let string = stringToArr.first {
            finalString = finalString + String(string.first!)
        }
        if let string = stringToArr.last {
            finalString = finalString + String(string.first!)
        }
        finalString = finalString.capitalized.uppercased()
        label.text = finalString
    }
    
    private func subViews(){
        profileImage.addSubview(label)
        contentView.addSubview(profileImage)
        contentView.addSubview(uploadButton)
    }
    private func configureLabel(){
        label.font = UIFont.systemFont(ofSize: 45, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
            label.topAnchor.constraint(equalTo:  profileImage.topAnchor),
            label.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor)
        ])
    }
    private func configureUploadButton(){
        uploadButton.addTarget(self, action: #selector(uploadImagePressed), for: .touchUpInside)
        uploadButton.setTitle("Edit Profile", for: .normal)

        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.backgroundColor    = .systemBlue
        uploadButton.tintColor          = .systemBackground
        uploadButton.contentMode        = .center
        uploadButton.clipsToBounds = true
        uploadButton.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            uploadButton.heightAnchor.constraint(equalToConstant: 45),
            uploadButton.widthAnchor.constraint(equalToConstant: 130),
            uploadButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            uploadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    @objc private func uploadImagePressed(){
        delgate?.editProfilePressed(self)
    }
    
    private func configureProfileImage(){
        profileImage.backgroundColor    = .systemGray6
        profileImage.layer.borderColor  = UIColor.systemGray3.cgColor
        profileImage.contentMode        = .scaleAspectFill
        profileImage.clipsToBounds      = true
        profileImage.layer.cornerRadius = 8
        profileImage.layer.borderWidth  = 0.75
       
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 18),
            profileImage.bottomAnchor.constraint(equalTo: uploadButton.topAnchor,constant: -18),
            profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    private func download (userID: String){
        APIManager.downloadAvtarImage(with: userID) { [weak self] (error, data) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.profileImage.image = image
                    self.label.removeFromSuperview()
                }
            }
        }
    }
}
