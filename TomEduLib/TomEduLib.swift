//
//  TomEduLib.swift
//  TomEduLib
//
//  Created by Федор Дуля on 02.07.2025.
//

import Foundation

public final class TomEduLib {
    public static let shared = TomEduLib()
    
    public let authState = AuthState()
    
    private init() {}
    
    @MainActor
    public func login(username: String, password: String) async -> ResponseAPI<AuthSummary> {
        let result = await LoginRequest.shared.Auth(username: username, password: password)
        
        if result.success, let payload = result.payload {
            _ = KeychainHelper.save(username, for: "TomEdu_username")
            _ = KeychainHelper.save(password, for: "TomEdu_password")
            
            // Теперь можно обновлять authState без DispatchQueue.main.async
            self.authState.currentUser = payload
            self.authState.isLoggedIn = true
            
            return ResponseAPI(success: true, message: result.message, payload: payload)
        } else if result.success {
            return ResponseAPI(
                success: result.success,
                message: "Критическая ошибка, свяжитесь с разработчиком: \(result.message)",
                errorType: result.errorType ?? .fatal
            )
        } else {
            return ResponseAPI(success: false, message: result.message, errorType: result.errorType ?? .fatal)
        }
    }
    
    @MainActor
    public func reauthenticate() async -> ResponseAPI<AuthSummary> {
        guard let username = KeychainHelper.read("TomEdu_username"),
              let password = KeychainHelper.read("TomEdu_password")
        
        else {
            return ResponseAPI(
                success: false,
                message: "Нет сохраненных данных авторизации",
                errorType: .warning)
        }
        
        return await login(username: username, password: password)
    }
    
    @MainActor
    public func restoreAuthState() async -> ResponseAPI<AuthSummary> {
        guard let _ = KeychainHelper.read("TomEdu_username"),
              let _ = KeychainHelper.read("TomEdu_password") else {
            authState.currentUser = nil
            authState.isLoggedIn = false
            return ResponseAPI(success: true, message: "", errorType: .none)
        }
        
        let response = await reauthenticate()
        
        // Обновляем authState, если авторизация успешна
        if response.success, let user = response.payload {
            authState.currentUser = user
            authState.isLoggedIn = true
        } else {
            authState.currentUser = nil
            authState.isLoggedIn = false
        }
        
        return response
    }
    
    @MainActor
    public func logout() {
        if authState.currentUser != nil {
            // Есть пользователь — выполняем выход
            KeychainHelper.delete("TomEdu_username")
            KeychainHelper.delete("TomEdu_password")
            
            authState.currentUser = nil
            authState.isLoggedIn = false
            print("Выход выполнен успешно")
        } else {
            print("Ошибка: нет авторизованного пользователя")
        }
    }

}
