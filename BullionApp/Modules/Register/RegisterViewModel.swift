//
//  RegisterViewModel.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 13/06/24.
//

import Foundation
import UIKit
import CryptoKit

class RegisterViewModel {
    var firstName: String = ""
    var lastName: String = ""
    var gender: String = ""
    var dateOfBirth: String = ""
    var email: String = ""
    var phone: String = ""
    var address: String = ""
    var photo: UIImage?
    var password: String = ""
    
    var onRegisterSuccess: (() -> Void)?
    var onRegisterError: ((String) -> Void)?
    
    func registerUser() {
        let hashedPassword = sha256(string: password)
        
        var user = [String: Any]()
        user["first_name"] = firstName
        user["last_name"] = lastName
        user["gender"] = gender
        user["date_of_birth"] = "\(dateOfBirth)T00:00:00.000Z"
        user["email"] = email
        user["phone"] = phone
        user["address"] = address
        user["password"] = hashedPassword
        
        print("Registering user with data: \(user)")
        sendRegistrationRequest(user: user)
    }
    
    private func sha256(string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    private func sendRegistrationRequest(user: [String: Any]) {
        guard let url = URL(string: "https://api-test.bullionecosystem.com/api/v1/auth/register") else {
            self.onRegisterError?("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = createMultipartBody(with: user, boundary: boundary)
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.onRegisterError?("Request error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse else {
                self.onRegisterError?("No response from server")
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let jsonResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if jsonResponse.status == 200 && !jsonResponse.isError {
                        print("Registration response: \(jsonResponse)")
                        self.onRegisterSuccess?()
                    } else {
                        self.onRegisterError?("Registration failed: \(jsonResponse.message)")
                    }
                } catch {
                    self.onRegisterError?("Failed to parse JSON response: \(error.localizedDescription). Response data: \(String(data: data, encoding: .utf8) ?? "No response data")")
                }
            } else {
                let responseString = String(data: data, encoding: .utf8) ?? "No response data"
                self.onRegisterError?("HTTP Status Code: \(httpResponse.statusCode). Response data: \(responseString)")
            }
        }
        
        task.resume()
    }
    
    private func createMultipartBody(with parameters: [String: Any], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        if let photo = self.photo {
            let filename = "photo.jpg"
            let mimetype = "image/jpeg"
            let imageData = photo.jpegData(compressionQuality: 1.0)!
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}

