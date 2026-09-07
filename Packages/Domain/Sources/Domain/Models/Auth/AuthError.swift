//
//  AuthError.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation

public enum AuthError: Error, LocalizedError, Equatable {
    case emailNotVerified
    case userDisabled
    case userNotFound
    case networkError
    case tooManyRequests
    case invalidEmail
    case missingEmail
    case wrongPassword
    case emailAlreadyInUse
    case accountExistsWithDifferentCredential
    case credentialAlreadyInUse
    case requiresRecentLogin
    case userCancelled
    case invalidCredential
    case uiError
    case unknown(underlying: NSError)

    public var errorDescription: String? {
        switch self {
        case .userDisabled:           String(localized: "Account has been disabled.")
        case .userNotFound:           String(localized: "No account found with these credentials.")
        case .networkError:           String(localized: "Network error occurred.")
        case .tooManyRequests:        String(localized: "Too many attempts. Please try again later.")
        case .invalidEmail:           String(localized: "Invalid email address format.")
        case .missingEmail:           String(localized: "Email address is absent.")
        case .wrongPassword:          String(localized: "Incorrect password.")
        case .emailAlreadyInUse:      String(localized: "This email is already registered.")
        case .accountExistsWithDifferentCredential:   String(localized: "An account already exists with this email address.")
        case .credentialAlreadyInUse: String(localized: "This credential is already linked to another account.")
        case .requiresRecentLogin:    String(localized: "Re-authentication required.")
        case .userCancelled:          String(localized: "Sign-in was cancelled.")
        case .invalidCredential:      String(localized: "Invalid authentication credentials.")
        case .uiError:                String(localized: "Unable to display sign-in interface.")
        case .emailNotVerified:       String(localized: "Email address not verified.")
        case .unknown(let underlying):                underlying.localizedDescription
        }
    }
}
