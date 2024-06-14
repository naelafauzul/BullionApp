//
//  UserDetailModel.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//

import Foundation
import UIKit

struct UserDetailResponse: Codable {
    var status: Int
    var iserror: Bool
    var message: String
    var data: UserDetail
}

struct UserDetail: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var gender: String
    var dateOfBirth: String
    var email: String
    var photo: String
    var phone: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case dateOfBirth = "date_of_birth"
        case email
        case photo
        case phone
        case address
    }
    
    var uiImage: UIImage? {
        guard var imageData = Data(base64Encoded: photo) else {
            print("Error converting base64 string to Data")
            return nil
        }
        return UIImage(data: imageData)
    }
}

