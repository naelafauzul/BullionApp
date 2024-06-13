//
//  RegisterModel.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//

import Foundation

struct RegisterModel: Codable {
    var firstName: String
    var lastName: String
    var gender: String
    var dateOfBirth: String
    var email: String
    var phone: String
    var address: String
    var photo: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case dateOfBirth = "date_of_birth"
        case email
        case phone
        case address
        case photo
        case password
    }
}

struct RegisterResponse: Codable {
    let status: Int
    let isError: Bool
    let message: String
    let data: RegisterData?
    
    enum CodingKeys: String, CodingKey {
        case status
        case isError = "iserror"
        case message
        case data
    }
}

struct RegisterData: Codable {
    let name: String
    let email: String
}

