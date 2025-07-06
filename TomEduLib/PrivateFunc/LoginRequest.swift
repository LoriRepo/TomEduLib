//
//  LoginAPI.swift
//  TomEdu
//
//  Created by Федор Дуля on 02.07.2025.
//

import Foundation
import CryptoKit

struct LoginData: Codable {
    let login: String
    let password: String
    let isRemember: Bool
}

internal class LoginRequest {
    static let shared = LoginRequest()
    
    private init() {}
    
    public func Auth(username: String, password: String) async -> responseAPI {
        
        // Ссылка авторизации
        guard let url = URL(string: "https://poo.tomedu.ru/services/security/login") else {
            return responseAPI(success: false, message: "Ошибка URL запроса авторизации", errorType: .fatal)
        }
        
        do {
            let loginData = LoginData(login: username, password: hashAndBase64Encode(password), isRemember: true)
            let jsonData = try JSONEncoder().encode(loginData)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        } catch {
            return responseAPI(success: false, message: "Ошибка кодирования запроса: \(error)", errorType: .fatal)
        }
        
        print ("\(username) | \(password)")
        return responseAPI(success: true, message: "Авторизовано")
    }
    
    private func hashAndBase64Encode(_ password: String) -> String {
        if let passwordData = password.data(using: .utf8) {
            let sha256 = SHA256.hash(data: passwordData)
            let passwordBase64 = Data(sha256).base64EncodedString()
            return passwordBase64
        }
        return ""
    }
}
