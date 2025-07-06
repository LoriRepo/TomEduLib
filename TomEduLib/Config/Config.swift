//
//  Config.swift
//  TomEdu
//
//  Created by Федор Дуля on 04.07.2025.
//

import Foundation

internal enum NetworkConfig {
    static let requestTimeout: TimeInterval = 5     // Таймаут на запрос (отправка + получение ответа)
    static let resourceTimeout: TimeInterval = 5    // Таймаут на весь ресурс (включая скачивание тела)
    
    // Базовая сессия для всех запросов
    static var session: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = requestTimeout
        config.timeoutIntervalForResource = resourceTimeout
        return URLSession(configuration: config)
    }
    
    // MARK: - Endpoints
    enum Endpoints {
        static let login = "https://poo.tomedu.ru/services/security/login"
    }
}
