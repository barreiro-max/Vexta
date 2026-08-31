//
//  AccountError.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation

public enum AccountError: Error, Equatable {
    case userNotFound
    case requiresRecentLogin
    case providerAlreadyLinked
    case credentialAlreadyInUse
    case userCancelled
    case networkError
    case tooManyRequests
    case uiError
    case unknown
}

extension AccountError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .userNotFound:            String(localized: "Account not found.")
        case .requiresRecentLogin:    String(localized: "Re-authentication required.")
        case .providerAlreadyLinked:  String(localized: "Provider already linked.")
        case .credentialAlreadyInUse: String(localized: "Credential in use by another account.")
        case .userCancelled:          String(localized: "Operation was cancelled.")
        case .networkError:           String(localized: "Network error occurred.")
        case .tooManyRequests:        String(localized: "Too many attempts. Please try again later.")
        case .uiError:                String(localized: "Unable to display interface.")
        case .unknown:                String(localized: "An unexpected error occurred.")
        }
    }

    public var failureReason: String? {
        switch self {
        case .userNotFound:            "No active user session was found for this operation."
        case .requiresRecentLogin:    "This operation is sensitive and requires a recent login session."
        case .providerAlreadyLinked:  "The selected authentication provider is already linked to this user."
        case .credentialAlreadyInUse: "This credential is associated with a different user account."
        case .userCancelled:          "The user explicitly cancelled the action flow."
        case .networkError:           "A network error occurred during the account modification request."
        case .tooManyRequests:        "All requests to the server have been blocked due to unusual activity."
        case .uiError:                "Could not present the required view controller for this account action."
        case .unknown:                "An unclassified account management error occurred."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .userNotFound:
            String(localized: "Please sign in again to restore your session.")
        case .requiresRecentLogin:
            String(localized: "Log out and log back in before attempting this action again.")
        case .providerAlreadyLinked:
            String(localized: "This provider is already connected. Use a different provider to link.")
        case .credentialAlreadyInUse:
            String(localized: "Try signing in with that provider account instead.")
        case .networkError, .tooManyRequests:
            String(localized: "Check your internet connection and try again in a few minutes.")
        case .userCancelled, .uiError:
            String(localized: "Please try performing the action again.")
        case .unknown:
            String(localized: "Please try again later or restart the app.")
        }
    }
}
