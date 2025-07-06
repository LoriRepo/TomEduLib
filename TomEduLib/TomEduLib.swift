//
//  TomEduLib.swift
//  TomEduLib
//
//  Created by Федор Дуля on 02.07.2025.
//

import Foundation

public final class TomEduLib {
    public static let shared = TomEduLib()
    
    private init() {}
    
    public func login(username: String, password: String) async -> ResponseAPI<AuthSummary> {
        let result = await LoginRequest.shared.Auth(username: username, password: password)
        if result.success == true {
            if let payload = result.payload {
                return ResponseAPI(success: true, message: result.message, payload: payload)
            }
            else {
                return ResponseAPI(
                    success: result.success,
                    message: "Критическая ошибка, свяжитесь с разработчиком: \(result.message)",
                    errorType: .fatal
                )
            }
        }
        else {
            return ResponseAPI(success: false, message: result.message, errorType: .warning)
        }
        
    }
}
