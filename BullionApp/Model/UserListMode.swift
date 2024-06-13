//
//  UserListMode.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 12/06/24.
//

import Foundation
import UIKit

struct UserListResponse: Codable {
    let status: Int
    let isError: Bool
    let message: String
    let data: [UserList]
    
    enum CodingKeys: String, CodingKey {
        case status
        case isError = "iserror"
        case message
        case data
    }
}

struct UserList: Codable {
    let id: String
    let name: String
    let gender: String
    let dateOfBirth: String
    let email: String
    let photo: String
    let address: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case gender
        case dateOfBirth = "date_of_birth"
        case email
        case photo
        case address
    }

    var uiImage: UIImage? {
        guard let imageData = Data(base64Encoded: photo) else {
            print("Error converting base64 string to Data")
            return nil
        }
        return UIImage(data: imageData)
    }
}
