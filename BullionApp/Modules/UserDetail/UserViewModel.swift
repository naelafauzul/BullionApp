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
    
    func deleteUser(userId: String, completion: @escaping (Bool, String?) -> Void) {
        guard let authToken = authToken else {
            completion(false, "No auth token available")
            return
        }
        
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/admin/\(userId)/delete") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Request error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let status = json?["status"] as? Int
                let isError = json?["iserror"] as? Bool
                let message = json?["message"] as? String
                
                if status == 200 && isError == false {
                    completion(true, message)
                } else {
                    completion(false, message ?? "Unknown error")
                }
            } catch {
                completion(false, "JSON parsing error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

