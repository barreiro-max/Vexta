//
//  AuthError.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation

public enum AuthError: Error {
    case userDisabled
    case userNotFound
    case networkError
    case tooManyRequests
    case invalidEmail
    case wrongPassword
    case emailAlreadyInUse
    case credentialAlreadyInUse
    case requiresRecentLogin
    case userCancelled
    case invalidCredential
    case uiError
    case unknown
}

extension AuthError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .userDisabled:           String(localized: "Account has been disabled.")
        case .userNotFound:           String(localized: "No account found with these credentials.")
        case .networkError:           String(localized: "Network error occurred.")
        case .tooManyRequests:        String(localized: "Too many attempts. Please try again later.")
        case .invalidEmail:           String(localized: "Invalid email address format.")
        case .wrongPassword:          String(localized: "Incorrect password.")
        case .emailAlreadyInUse:      String(localized: "This email is already registered.")
        case .credentialAlreadyInUse: String(localized: "This credential is already linked to another account.")
        case .requiresRecentLogin:    String(localized: "Re-authentication required.")
        case .userCancelled:          String(localized: "Sign-in was cancelled.")
        case .invalidCredential:      String(localized: "Invalid authentication credentials.")
        case .uiError:                String(localized: "Unable to display sign-in interface.")
        case .unknown:                String(localized: "An unexpected error occurred.")
        }
    }

    public var failureReason: String? {
        switch self {
        case .userDisabled:           "The user account has been disabled by an administrator."
        case .userNotFound:           "No user record corresponding to this identifier was found."
        case .networkError:           "A network error occurred during the authentication request."
        case .tooManyRequests:        "All requests to the server have been blocked due to unusual activity."
        case .invalidEmail:           "The email address string is malformed."
        case .wrongPassword:          "The password provided is invalid for the given user."
        case .emailAlreadyInUse:      "The email address is already in use by another account."
        case .credentialAlreadyInUse: "This credential is already associated with an existing user account."
        case .requiresRecentLogin:    "This operation is sensitive and requires recent authentication."
        case .userCancelled:          "The user explicitly cancelled the authentication flow."
        case .invalidCredential:      "The supplied authentication credentials are malformed or expired."
        case .uiError:                "Could not present the sign-in controller or top view controller."
        case .unknown:                "An unclassified authentication error occurred."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .userDisabled:
            String(localized: "Please contact support for assistance.")
        case .userNotFound, .invalidEmail:
            String(localized: "Check your email address and try again, or sign up for a new account.")
        case .wrongPassword:
            String(localized: "Double-check your password or reset it.")
        case .emailAlreadyInUse:
            String(localized: "Try logging in instead, or use a different email address.")
        case .credentialAlreadyInUse:
            String(localized: "Log in using the original provider linked to this account.")
        case .requiresRecentLogin:
            String(localized: "Log out and log back in before attempting this action again.")
        case .networkError, .tooManyRequests:
            String(localized: "Check your internet connection and try again in a few minutes.")
        case .userCancelled, .uiError, .invalidCredential:
            String(localized: "Please try signing in again.")
        case .unknown:
            String(localized: "Please try again later or restart the app.")
        }
    }
}

extension AuthError: CaseIterable {}
