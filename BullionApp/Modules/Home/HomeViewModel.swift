//
//  HomeViewModel.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 12/06/24.
//

import Foundation

class HomeViewModel {
    var userList: [UserList] = []
    var authToken: String?
    
    func fetchUsers(completion: @escaping () -> Void) {
        guard let authToken = authToken else {
            print("No auth token available")
            return
        }
        
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/admin/?offset=35&limit=10") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "No readable data")
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserListResponse.self, from: data)
                self.userList = response.data
                completion()
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

    func fetchUserDetail(userId: String, completion: @escaping (UserDetail?) -> Void) {
        guard let authToken = authToken else {
            print("No auth token available")
            return
        }
        
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/admin/\(userId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserDetailResponse.self, from: data)
                completion(response.data)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}


