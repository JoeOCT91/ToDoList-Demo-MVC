//
//  APIManager.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    class func login(with email: String, password: String, completion: @escaping (_ error: Error?, _ loginData: LoginResponse?) -> Void) {
        
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json"]
        let params: [String: Any] = [ParameterKeys.email: email,
                                     ParameterKeys.password: password]
        
        AF.request(URLs.login, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let loginData = try decoder.decode(LoginResponse.self, from: data)
                completion(nil, loginData)
            } catch let error {
                print(error)
            }
        }
    }
    class func signup(with name: String, email: String, password: String, age: String,
                      completion: @escaping (_ error: Error?, _ loginData: LoginResponse?) -> Void) {
        print(name + email + password + age)
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json"]
        let params: [String: String] = [ParameterKeys.name: name,
                                     ParameterKeys.email: email,
                                     ParameterKeys.password: password,
                                     ParameterKeys.age: age]
        
        AF.request(URLs.signup, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let loginData = try decoder.decode(LoginResponse.self, from: data)
                completion(nil, loginData)
            } catch let error {
                print(error)
            }
        }
    }
    class func getTasks(completion: @escaping (_ error: Error?, _ loginData: TasksResponse?) -> Void) {
        
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json",
                                    HeaderKeys.authorization: Authorization.key]
        
        AF.request(URLs.newTask, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tasks = try decoder.decode(TasksResponse.self, from: data)
                completion(nil, tasks)
            } catch let error {
                print(error)
            }
        }
    }
    class func SaveTask(with body: String,
                        completion: @escaping (_ error: Error?, _ loginData: NewTaskResponse?) -> Void) {
        
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json",
                                    HeaderKeys.authorization: Authorization.key]
        let params: [String: String] = [ParameterKeys.body: body]
        
        AF.request(URLs.newTask, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newTask = try decoder.decode(NewTaskResponse.self, from: data)
                completion(nil, newTask)
            } catch let error {
                print(error)
            }
        }
    }
    class func deleteTask(with task: TaskData, completion: @escaping (_ error: Error?, _ data: Data?) -> Void) {
        let taskEndPoint = URLs.newTask + "/\(task.id)"
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json",
                                    HeaderKeys.authorization: Authorization.key]

        AF.request(taskEndPoint, method: HTTPMethod.delete, headers: headers).response { response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let response = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                guard  let response = try JSONSerialization.jsonObject(with: response, options: []) as? [String : Any] else { return }
                completion(nil, nil)
            } catch let error {
                print(error)
            }
        }
    }
    
    class func editTask(with task: TaskData, completion: @escaping (_ error: Error?, _ loginData: NewTaskResponse?) -> Void) {
        let taskEndPoint = URLs.newTask + "/\(task.id)"
        let headers: HTTPHeaders = [HeaderKeys.contentType: "application/json",
                                    HeaderKeys.authorization: Authorization.key]
        let parameters: [String : Any] = ["completed"   : task.status,
                                          "description" : task.body]
        
        AF.request(taskEndPoint, method: HTTPMethod.put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tasks = try decoder.decode(NewTaskResponse.self, from: data)
                completion(nil, tasks)
            } catch let error {
                print(error)
            }
        }
    }
    
    class func getUserInfo( completion: @escaping (_ error: Error?, _ userData: UserData?) -> Void) {
        let taskEndPoint = URLs.user + "/me"
        let headers: HTTPHeaders = [HeaderKeys.authorization: Authorization.key]
        
        AF.request(taskEndPoint, method: HTTPMethod.get, headers: headers).response { response in
            
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserData.self, from: data)
                completion(nil, user)
            } catch let error {
                print(error)
            }
        }
    }
    
    class func downloadAvtarImage(with userID: String, completion: @escaping (_ error: Error?, _ data: Data?) -> Void) {
        let avtarEndPoint = URLs.user + "/\(userID)/avatar"
        print(avtarEndPoint)
        AF.request(avtarEndPoint, method: HTTPMethod.get, encoding: JSONEncoding.default).response {
            response in
            guard response.error == nil else {
                print(response.error!)
                completion(response.error, nil)
                return
            }
            guard let data = response.data else {
                print("didn't get any data from API")
                return
            }
            completion(nil, data)
        }
    }
}


