//
//  LoginViewModel.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 12/06/24.
//

import Foundation
import CryptoKit

class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    var authToken: String? // Properti untuk menyimpan token
    
    var onLoginSuccess: ((User) -> Void)?
    var onLoginError: ((String) -> Void)?
    
    func login() {
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/auth/login") else {
            self.onLoginError?("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encrypt the password with SHA-256
        let encryptedPassword = sha256(password)
        
        let body: [String: Any] = [
            "email": email,
            "password": encryptedPassword
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.onLoginError?(error.localizedDescription)
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                self.onLoginError?("Invalid response from server")
                return
            }

            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = jsonResponse["token"] as? String { // Mendapatkan token dari respons JSON
                self.authToken = token // Menyimpan token
                print("Token:", token)
            }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                print("Login success:", apiResponse)
                self.onLoginSuccess?(apiResponse.data)
            } catch {
                self.onLoginError?("Failed to decode response: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
}

struct APIResponse: Codable {
    let status: Int
    let iserror: Bool
    let message: String
    let data: User
}
