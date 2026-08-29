//
//  AuthProviderOption.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation

public enum AuthProviderOption: Sendable {
    case email(email: String, password: String)
    case google
    case apple
    case facebook

    public var title: String {
        switch self {
        case .apple:
            "Apple"
        case .email:
            "Email"
        case .google:
            "Google"
        case .facebook:
            "Facebook"
        }
    }
}
