//
//  GetVersionResponse.swift
//  TomEdu
//
//  Created by Федор Дуля on 26.09.2025.
//

import Foundation


public struct VersionInfo: Codable {
    public let success: Bool
    public let version: String?
    public let build: String?
    public let message: String?

    public init(version: String?, build: String?) {
        self.success = true
        self.version = version
        self.build = build
        self.message = nil
    }

    public init(errorMessage: String) {
        self.success = false
        self.version = nil
        self.build = nil
        self.message = errorMessage
    }
}
