//
//  AppStateCordinator.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 01/12/2020.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

protocol AppStateManagerProtocol {
    func start(appDelgate: AppDelegateProtocol)
}

class AppStateManager {
     
    //MARK:- SingleTune
    private static let sharedInstance = AppStateManager()
    class func shared() -> AppStateManager {
        return sharedInstance
    }
    
    
    //MARK:- App state enum
    enum State {
        case none
        case auth
        case main
    }
    
    //MARK:- Properties
    var appDelgate: AppDelegateProtocol!
    var mainWindow: UIWindow? {
        return self.appDelgate.getMainWindow()
    }
    
    var state: State = .none {
        willSet(newState) {
            switch(newState) {
            case .auth:
                switchToAuthState()
                return
            case .main:
                switchToMainState()
                return
            default:
                return
            }
        }
    }
    //MARK:- App state change functions
    func switchToMainState() {
        let todoListVC = TodoListVC.create()
        let navigationController = UINavigationController(rootViewController: todoListVC)
        self.mainWindow?.rootViewController = navigationController
    }
    
    func switchToAuthState() {
        let signInVC = SignInVC.create()
        signInVC.delgate = self
        let navigationController = UINavigationController(rootViewController: signInVC)
        self.mainWindow?.rootViewController = navigationController
    }
}

extension AppStateManager: AppStateManagerProtocol {
    func start(appDelgate: AppDelegateProtocol){
        self.appDelgate = appDelgate
        
        if UserDefaultsManager.shared().token != nil {
            state = .main
        } else {
            state = .auth
        }
    }
}
extension AppStateManager: AuthNavigationDelgate {
    
    func showAuthState() {
        state = .auth
    }
    
    func showMainState(){
        state = .main
    }
}
