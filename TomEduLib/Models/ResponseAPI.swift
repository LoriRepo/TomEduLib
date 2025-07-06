//
//  PublicModel.swift
//  TomEduLib
//
//  Created by Федор Дуля on 02.07.2025.
//

// Enum типов ошибок
public enum ErrorLevel: Int, Codable {
    case none = 0
    case warning = 1
    case serverIssue = 2
    case fatal = 3
}

// Ответ для вызова API

public struct responseAPI {
    public let success: Bool
    public let message: String?
    public let errorType: ErrorLevel?
    
    public init(success: Bool, message: String?, errorType: ErrorLevel = .none) {
        self.success = success
        self.message = message
        self.errorType = errorType
    }
}
