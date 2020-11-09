//
//  httpBody.swift
//  TODOApp-MVC-Demo
//
//  Created by Yousef Mohamed on 09/11/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//


import Foundation

struct HttpBody: Codable {
    
    private var age: Int?
    private var name: String?
    private var email: String?
    private var complated: Bool?
    private var description: String?
    
    
    init(age: Int, name :String, email: String) {
        self.age = age
        self.name = name
        self.email = email
    }
    init(complated: Bool, description: String) {
        self.description = description
        self.complated = complated
    }
    
    func encode() -> Data? {
        encodeToJSON(self)
    }
    private func encodeToJSON<T: Codable>(_ body: T) -> Data? {
        do {
            //let anyEncodable = AnyEncodable(body)
            let jsonData = try JSONEncoder().encode(body)
            //let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            return jsonData
        } catch {
            print(error)
            return nil
        }
    }
}
// type-erasing wrapper
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
