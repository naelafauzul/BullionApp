//
//  UserDetailModel.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//

import Foundation

struct UserDetailResponse: Codable {
    let status: Int
    let iserror: Bool
    let message: String
    let data: UserDetail
}

struct UserDetail: Codable {
    let id: String
    let name: String
    let gender: String
    let dateOfBirth: String
    let email: String
    let photo: String
    let phone: String
    let address: String
}

