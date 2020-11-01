//
//  ProfileViewController.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 31/10/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    fileprivate var tableView = UITableView()
    var user: UserData!
    var labelFont: UIFont = UIFont.systemFont(ofSize: 22, weight: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    //MARK:- Private Methods
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
    
    
    //MARK:- Public Methods
    
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.profileVC)
        return profileVC
    }
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
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
            cell.configure(userID: user.id)
            
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
            logoutButton.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)
            
        return cell
        }
    }
    
    @objc func checkTapped() {
        let signoutAlert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out", preferredStyle: UIAlertController.Style.alert)

        signoutAlert.addAction(UIAlertAction(title: "Sign out", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaultsManager.shared().token = nil
            let signinVC = SignInVC.create()
            self.navigationController?.viewControllers.removeAll()
            let navigationController = UINavigationController(rootViewController: signinVC)
            AppDelegate.shared().window?.rootViewController?.dismiss(animated: false, completion: nil)
            AppDelegate.shared().window?.rootViewController = navigationController
        }))

        signoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    
        }))

        present(signoutAlert, animated: true, completion: nil)
    }
}
