//
//  GetVersionRequest.swift
//  TomEdu
//
//  Created by Федор Дуля on 26.09.2025.
//

import Foundation

internal class GetVersionRequest {
    static let shared = GetVersionRequest()
    
    private init() {}

    public func getRemoteVersion() async -> VersionInfo {
        guard let url = URL(string: "https://raw.githubusercontent.com/LoriRepo/TomEduApp/refs/heads/main/version.json?token=GHSAT0AAAAAADL7YPFD6LNPD3EM3VAQW3GQ2GW7OZQ") else {
            return VersionInfo(errorMessage: "Некорректная ссылка на проверку версии")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Сначала печатаем что пришло с GitHub
            if let rawString = String(data: data, encoding: .utf8) {
                print("Полученный JSON с GitHub: \(rawString)")
            } else {
                print("Не удалось прочитать данные как строку")
            }
            
            // Декодируем JSON только с version и build
            let decoded = try JSONDecoder().decode([String: String].self, from: data)
            let version = decoded["version"]
            let build = decoded["build"]
            
            return VersionInfo(version: version, build: build)
        } catch {
            return VersionInfo(errorMessage: "Ошибка получения версии: \(error.localizedDescription)")
        }
    }
}



