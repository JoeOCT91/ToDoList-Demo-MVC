//
//  APIRouter.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 08/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible{
    
    // The endpoint name
    case login(_ email: String, _ password: String)
    case signUP(_ name: String, _ email: String, _ password: String, _ age: String)
    case getTodos
    case newTask(_ body: String)
    case updateUserProfile(_ user: UserData)
    case editTask(_ task: TaskData)
    case downloadAvtarImage(_ userID: String)
    case getUserInfo
    case deleteTask(_ task: TaskData)
    
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getTodos, .downloadAvtarImage, .getUserInfo:
            return .get
        case .updateUserProfile, .editTask:
            return .put
        case .deleteTask:
            return .delete
        default:
            return .post
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [ParameterKeys.email: email, ParameterKeys.password: password]
        case .signUP(let name, let email, let password, let age):
            return [ParameterKeys.name: name, ParameterKeys.email: email, ParameterKeys.password: password, ParameterKeys.age: age]
        default:
            return nil
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return URLs.login
        case .signUP:
            return URLs.signup
        case .getTodos:
            return URLs.newTask
        case .newTask:
            return URLs.newTask
        case .updateUserProfile:
            return URLs.editUser
        case .editTask(let task), .deleteTask(let task):
            return URLs.newTask + "/\(task.id)"
        case .downloadAvtarImage(let userID):
            return URLs.user + "/\(userID)/avatar"
        case .getUserInfo:
            return URLs.userInfo
        }
        
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try URLs.base.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //httpMethod
        urlRequest.httpMethod = method.rawValue
        
        //Http Headers
        switch self {
        case .getTodos, .newTask, .updateUserProfile, .editTask, .getUserInfo, .deleteTask:
            urlRequest.setValue(Authorization.authValue, forHTTPHeaderField: HeaderKeys.authorization)
        default:
            break
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: HeaderKeys.contentType)
        
        // HTTP Body
        let httpBody: Data? = {
            switch self {
            case .newTask(let body):
                let httpBody = HttpBody(complated: false, description: body).encode()
                return httpBody
            case .updateUserProfile(let user):
                let httpBody = HttpBody(age: user.age, name: user.name, email: user.email).encode()
                return httpBody
            case .editTask(let task):
                let httpBody = HttpBody(complated: task.status, description: task.body).encode()
                return httpBody
            default:
                return nil
            }
        }()
        
        urlRequest.httpBody = httpBody
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get, .delete:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        //print(try encoding.encode(urlRequest, with: parameters))
        return try encoding.encode(urlRequest, with: parameters)
    }
}


