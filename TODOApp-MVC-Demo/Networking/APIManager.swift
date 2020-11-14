//
//  APIManager.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Moahmed on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    //MARK:- Login
    class func  login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>)-> ()){
        request(APIRouter.login(email, password)){ (response) in
            completion(response)
        }
    }
    
    //MARK:- Signup
    class func signUP(with name: String, email: String, password: String, age: String,
                      complation: @escaping (Result<LoginResponse, Error>) -> ()) {
        request(APIRouter.signUP(name, email, password, age)) { (response) in
            complation(response)
        }
    }
    
    //MARK:- Get TODOS
    class func getTasks(completion: @escaping (Result<TasksResponse, Error>)-> ()){
        request(APIRouter.getTodos){ (response) in
            completion(response)
        }
    }
    //MARK:- Add New Task
    class func addNewTask(with body: String,complation: @escaping (Result<NewTaskResponse, Error>) -> ()) {
        request(APIRouter.newTask(body)) { (response) in
            complation(response)
        }
    }
    //MARK:- Delete Task
    class func deleteTask(with task: TaskData, complation: @escaping (Result<Data, Error>) -> ()){
        request(APIRouter.deleteTask(task)) { (response) in
            complation(response)
        }
    }

    class func editTask(with task: TaskData, complation: @escaping (Result<NewTaskResponse, Error>) -> ()){
        request(APIRouter.editTask(task)) { (response) in
            complation(response)
        }
    }
    
    //MARK:- Update Profile Information
    class func updateUserProfile(with user: UserData, complation: @escaping (Result<UserData, Error>) -> ()) {
        request(APIRouter.updateUserProfile(user)) { (response) in
            complation(response)
        }
    }
    class func getUserInfo(complation: @escaping (Result<UserData, Error>) -> ()){
        request(APIRouter.getUserInfo) { response in
            complation(response)
        }
    }
       
    class func downloadAvtarImage (with userID: String, complation: @escaping (Result<Data, Error>) -> ()){
        AF.request(APIRouter.downloadAvtarImage(userID)).response { (response) in
            if let data = response.data{ complation(.success(data))
            } else if let error = response.error { complation(.failure(error)) }
        }   
    }

    // Upload user profile image
    class func uploadProfileImage(with image: UIImage, completion: @escaping (Result<Bool,Error>) -> Void) {
        let headers: HTTPHeaders = [HeaderKeys.authorization: Authorization.authValue]
        let imgData = image.jpegData(compressionQuality: 0.5)!
        let multipartFormData = MultipartFormData()
        multipartFormData.append(imgData, withName: "avatar", fileName: "/ProfileImage.jpg", mimeType: "image/jpg")
        AF.upload(multipartFormData: multipartFormData, to:URLs.upload, method: .post, headers: headers).response {
            response in
            guard response.error == nil else {
                completion(.failure(response.error!))
                return
            }
            completion(.success(true))
        }
    }
}

extension APIManager{
    // MARK:- The request function to get results in a closure
    private static func request<T: Decodable>(_ urlConvertible: URLRequestConvertible, completion:  @escaping (Result<T, Error>) -> ()) {
        // Trigger the HttpRequest using AlamoFire
        AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
