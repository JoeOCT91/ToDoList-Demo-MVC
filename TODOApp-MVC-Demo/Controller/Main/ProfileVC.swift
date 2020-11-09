//
//  ProfileViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 31/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- Proprties
    var user: UserData!
    private var tableView           = UITableView()
    private let labelFont: UIFont   = UIFont.systemFont(ofSize: 22, weight: .medium)
    private let imagePicker         = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    //MARK:- Private Methods
    private func configureNavBar(){
        let uploadButton = UIBarButtonItem(title: "Upload Image", style: .done, target: self, action: #selector(uploadImagePressed))
        navigationItem.rightBarButtonItem = uploadButton
    }
    
    fileprivate func configureTableView(){
        view.addSubview(tableView)
        tableView.register(ProfilePictureTableViewCell.self, forCellReuseIdentifier: ProfilePictureTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.separatorStyle    = .none
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func presentError(with message: String) {
        self.showAlert(title: "Sorry", message: message)
    }
    
    //MARK:- Public Methods
    
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.profileVC)
        return profileVC
    }
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource, EditProfileDelgate {
    
    
    func editProfilePressed(_ cell: ProfilePictureTableViewCell) {
        //        let editProfileVc = EditProfileVC.create()
        //        editProfileVc.modalPresentationStyle    = .overCurrentContext
        //        editProfileVc.modalTransitionStyle      = .crossDissolve
        //        editProfileVc.userData = user
        //        editProfileVc.complation = { user in
        //            self.tableView.reloadData()
        //            self.user = user
        //        }
        //        present(editProfileVc, animated: true)
        promptForAnswer()
    }
    func promptForAnswer() {
        let editAlert = UIAlertController(title: "Edit eser information", message: nil, preferredStyle: .alert)
        editAlert.addTextField { (textField : UITextField) in
            textField.text = self.user.name
        }
        editAlert.addTextField { (textField : UITextField) in
            textField.text = self.user.email
        }
        editAlert.addTextField { (textField : UITextField) in
            textField.text = String(self.user.age)
        }
        
        let submitAction = UIAlertAction(title: "Save", style: .default) {
            [unowned editAlert, weak self] _ in
            guard let self = self else { return }
            self.user.name  = editAlert.textFields![0].text!
            self.user.email = editAlert.textFields![1].text!
            self.user.age   = Int(editAlert.textFields![2].text!)!
            APIManager.updateUserProfile(with: self.user) { (result) in
                self.tableView.reloadData()
                }
            }
        editAlert.addAction(submitAction)
        present(editAlert, animated: true)
    }
    
    @objc func uploadImagePressed(_ cell: ProfilePictureTableViewCell) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        view.showLoader()
        APIManager .uploadProfileImage(with: pickedImage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure :
                self.view.hideLoader()
                self.presentError(with: "Unable to upload new profile image")
                return
            case .success:
                self.updateProfilePic(with: pickedImage)
                self.view.hideLoader()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func updateProfilePic(with image: UIImage){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell  = tableView.cellForRow(at: indexPath) as! ProfilePictureTableViewCell
        cell.setProfileImage(image: image)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePictureTableViewCell.identifier,
                                                     for: indexPath) as! ProfilePictureTableViewCell
            cell.configure(userID: user.id, name: user.name)
            cell.delgate = self
            
            return cell
        } else if indexPath.row == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Name\t: \(user.name)"
            cell.textLabel?.font = labelFont
            return cell
        } else if indexPath.row == 2 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Email\t\t: \(user.email)"
            cell.textLabel?.font = labelFont
            return cell
        } else if indexPath.row == 3 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Age\t\t: \(user.age)"
            cell.textLabel?.font = labelFont
            return cell
        } else {
            let cell                        = UITableViewCell()
            let logoutButton                = UIButton()
            logoutButton.backgroundColor    = .systemBlue
            logoutButton.setTitle("Sign out", for: .normal)
            logoutButton.titleLabel?.font   = labelFont
            logoutButton.tintColor          = .systemBackground
            logoutButton.clipsToBounds      = true
            logoutButton.layer.cornerRadius = 8
            
            cell.contentView.addSubview(logoutButton)
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                logoutButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 60),
                logoutButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                logoutButton.heightAnchor.constraint(equalToConstant: 55),
                logoutButton.widthAnchor.constraint(equalToConstant: 150),
                logoutButton.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
            ])
            logoutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc private func logOutTapped() {
        let signoutAlert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out", preferredStyle: UIAlertController.Style.alert)
        
        signoutAlert.addAction(UIAlertAction(title: "Sign out", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
                UserDefaultsManager.shared().token = nil
                let signinVC = SignInVC.create()
                let navigationController = UINavigationController(rootViewController: signinVC)
                AppDelegate.shared().window?.rootViewController = navigationController
            }
        }))
        signoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(signoutAlert, animated: true, completion: nil)
    }
}
