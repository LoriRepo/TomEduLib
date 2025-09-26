//
//  AuthState.swift
//  TomEdu
//
//  Created by Федор Дуля on 21.09.2025.
//

import Foundation

public class AuthState: ObservableObject {
    @Published public var currentUser: AuthSummary? = nil
    @Published public var isLoggedIn: Bool = false
    
    public init() {}
}
