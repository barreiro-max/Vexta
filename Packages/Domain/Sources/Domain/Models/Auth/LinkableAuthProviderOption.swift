//
//  LinkableAuthProviderOption.swift
//  Vexta
//
//  Created by MaxAdmin on 30.08.2026.
//

import Foundation

public enum LinkableAuthProviderOption: Sendable {
    case email(email: String, password: String)
    case google
    case apple
    case facebook

    public var domain: String {
        switch self {
        case .email:
            "password"
        case .google:
            "google.com"
        case .apple:
            "apple.com"
        case .facebook:
            "facebook.com"
        }
    }
}
