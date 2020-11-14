//
//  AuthAlertVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 11/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class AuthAlertVC: UIViewController {
    
    let containerView   = UIView()
    let tittleLabel = UILabel()
    let bodyLabel = UILabel()
    let actionButton = UIButton()
    
    var alertTittle: String?
    var alertBody: String?
    var actionTittle: String?
    
    init(alertTittle: String, alertBody: String, actionTittle: String){
        super.init(nibName: nil, bundle: nil)
        self.alertTittle = alertTittle
        self.alertBody = alertBody
        self.actionTittle = actionTittle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
 
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    



}
