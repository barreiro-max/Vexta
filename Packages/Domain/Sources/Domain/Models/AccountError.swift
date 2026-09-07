//
//  AccountError.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation

public enum AccountError: Error, LocalizedError, Equatable {
    case userNotFound
    case requiresRecentLogin
    case providerAlreadyLinked
    case credentialAlreadyInUse
    case invalidCredentials
    case missingEmail
    case invalidEmail
    case noSuchProvider
    case cannotUnlinkLastProvider
    case userCancelled
    case networkError
    case tooManyRequests
    case uiError
    case unknown(underlying: NSError)

    public var errorDescription: String? {
        switch self {
        case .userNotFound:             String(localized: "Account not found.")
        case .requiresRecentLogin:      String(localized: "Re-authentication required.")
        case .providerAlreadyLinked:    String(localized: "Provider already linked.")
        case .credentialAlreadyInUse:   String(localized: "Credential in use by another account.")
        case .missingEmail:             String(localized: "Email address is absent.")
        case .invalidEmail:             String(localized: "Invalid email address format.")
        case .noSuchProvider:           String(localized: "No such provider exists")
        case .cannotUnlinkLastProvider: String(localized: "Can't unlink last provider")
        case .invalidCredentials:       String(localized: "Credential is invalid")
        case .userCancelled:            String(localized: "Operation was cancelled.")
        case .networkError:             String(localized: "Network error occurred.")
        case .tooManyRequests:          String(localized: "Too many attempts. Please try again later.")
        case .uiError:                  String(localized: "Unable to display interface.")
        case .unknown(let underlying):  underlying.localizedDescription
        }
    }
}
