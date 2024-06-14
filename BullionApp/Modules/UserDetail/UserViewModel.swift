//
//  UserViewModel.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 14/06/24.
//

import Foundation
import UIKit

class UserDetailViewModel {
    var authToken: String?
    var userDetail: UserDetail?
    
    func fetchUserDetail(userId: String, completion: @escaping (Bool, String?) -> Void) {
        guard let authToken = authToken else {
            completion(false, "No auth token available")
            return
        }
        
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/admin/\(userId)") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserDetailResponse.self, from: data)
                self.userDetail = response.data
                completion(true, nil)
            } catch {
                completion(false, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func updateUserDetail(userId: String, completion: @escaping (Bool, String?) -> Void) {
        guard let authToken = authToken else {
            completion(false, "No auth token available")
            return
        }
        
        guard let userDetail = userDetail else {
            completion(false, "User detail not available")
            return
        }
        
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/admin/\(userId)/update") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "first_name": userDetail.firstName,
            "last_name": userDetail.lastName,
            "gender": userDetail.gender,
            "date_of_birth": userDetail.dateOfBirth,
            "email": userDetail.email,
            "phone": userDetail.phone,
            "address": userDetail.address
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            completion(false, "Failed to encode request body")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserDetailResponse.self, from: data)
                self.userDetail = response.data
                completion(true, nil)
            } catch {
                completion(false, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func uploadPhoto(userId: String, image: UIImage, completion: @escaping (Bool, String?) -> Void) {
        guard let authToken = authToken else {
            completion(false, "No auth token available")
            return
        }
        
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/admin/\(userId)/uploadPhoto") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        httpBody.appendString("--\(boundary)\r\n")
        httpBody.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n")
        httpBody.appendString("Content-Type: image/jpeg\r\n\r\n")
        httpBody.append(imageData!)
        httpBody.appendString("\r\n")
        httpBody.appendString("--\(boundary)--\r\n")
        
        request.httpBody = httpBody as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserDetailResponse.self, from: data)
                self.userDetail = response.data
                completion(true, nil)
            } catch {
                completion(false, error.localizedDescription)
            }
        }
        
        task.resume()
    }
}

private extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
