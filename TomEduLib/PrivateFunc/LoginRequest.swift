//
//  LoginAPI.swift
//  TomEdu
//
//  Created by Федор Дуля on 02.07.2025.
//

import Foundation
import CryptoKit

// MARK: - Данные обработки ошибок

struct ErrorResponse: Codable {
    let responseStatus: ResponseStatus
}

struct ResponseStatus: Codable {
    let message: String
}

// MARK: - Данные отправляемые на сервер авторизации

struct LoginData: Codable {
    let login: String
    let password: String
    let isRemember: Bool
}

// MARK: - Класс авторизации
internal class LoginRequest {
    static let shared = LoginRequest()
    
    private init() {}
    
    public func Auth(username: String, password: String) async -> ResponseAPI<AuthSummary> {
        
        // Ссылка авторизации
        guard let url = URL(string: NetworkConfig.Endpoints.login) else {
            return ResponseAPI(success: false, message: "Ошибка URL запроса авторизации", errorType: .fatal)
        }
        
        do {
            let loginData = LoginData(login: username, password: hashAndBase64Encode(password), isRemember: true)
            let jsonData = try JSONEncoder().encode(loginData)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = NetworkConfig.session
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return ResponseAPI(success: false, message: "Ошибка неккоректный ответ сервера", errorType: .fatal)
            }
            
            let decoder = JSONDecoder()
            
            switch httpResponse.statusCode {
                case 200:
                    let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                    //print (loginResponse)
                    if let summary = extractSummary(from: loginResponse) {
                        if summary.userID == 0 {
                            return ResponseAPI(success: false, message: "Ошибка декодирования", errorType: .fatal)
                        }
                        else {
                            return ResponseAPI(success: true, message: "Авторизовано", payload: summary)
                        }
                }
                else {
                    return ResponseAPI(success: false, message: "Ошибка декодирования", errorType: .fatal)
                }
                
                case 400, 401:
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                    return ResponseAPI(success: false, message: errorResponse.responseStatus.message, errorType: .warning)
                
                default:
                    return ResponseAPI(success: false, message: "Ошибка чтения данных", errorType: .warning)
            }
            
        } catch {
            if (error as? URLError)?.code == .timedOut {
                return ResponseAPI(success: false, message: "Время ожидания ответа истекло. Возможно включен VPN", errorType: .warning)
            }
            return ResponseAPI(success: false, message: "Ошибка выполнения запроса: \(error.localizedDescription)", errorType: .fatal)
        }
    }
    
    private func hashAndBase64Encode(_ password: String) -> String {
        if let passwordData = password.data(using: .utf8) {
            let sha256 = SHA256.hash(data: passwordData)
            let passwordBase64 = Data(sha256).base64EncodedString()
            return passwordBase64
        }
        return ""
    }
    
    func extractSummary(from loginResponse: LoginResponse) -> AuthSummary? {
        guard let tenat = loginResponse.tenants.first?.value else {return nil}
        
        let organizationName = tenat.settings.organization.shortName
        let groupID = tenat.studentRole.students.first?.groupName ?? "Н/а"
        let userID = tenat.studentRole.students.first?.groupId ?? 0
        let firstName = tenat.firstName
        let lastName = tenat.lastName
        let middleName = tenat.middleName
        
        return AuthSummary(
            organizationName: organizationName,
            groupID: groupID,
            userID: userID,
            firstName: firstName,
            lastName: lastName,
            middleName: middleName
        )
    }
}
