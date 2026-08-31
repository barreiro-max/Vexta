//
//  AccountErrorMapper.swift
//  Vexta
//
//  Created by MaxAdmin on 31.08.2026.
//

import Foundation
import Domain
import FirebaseAuth

extension AccountError {

    public init(from error: any Error) {
        switch error {
            
        case let accountError as AccountError:
            self = accountError

        case let googleSignInError as GoogleSignInError:
            self.init(from: googleSignInError)

        case let appleSignInError as AppleSignInError:
            self.init(from: appleSignInError)

        case let facebookSignInError as FacebookSignInError:
            self.init(from: facebookSignInError)

        default:
            let nsError = error as NSError
            let authErrorCode = AuthErrorCode(rawValue: nsError.code)
            self.init(from: authErrorCode)
        }
    }

    private init(from googleSignInError: GoogleSignInError) {
        self = switch googleSignInError {
        case .cannotFindTopViewController, .invalidRestorePreviousSignIn, .invalidSignIn, .invalidIdToken:
            .uiError
        }
    }

    private init(from appleSignInError: AppleSignInError) {
        self = switch appleSignInError {
        case .cannotFindTopViewController, .invalidAppleIdCredential:
            .uiError
        }
    }

    private init(from facebookSignInError: FacebookSignInError) {
        self = switch facebookSignInError {
        case .cannotFindTopViewController:
            .uiError
        case .userCancelled:
            .userCancelled
        case .invalaidCurrentNonce, .missingLoginConfiguration, .invalidAccessToken:
            .unknown
        }
    }

    private init(from authErrorCode: AuthErrorCode?) {
        self = switch authErrorCode {
        case .userNotFound:
            .userNotFound
        case .requiresRecentLogin:
            .requiresRecentLogin
        case .providerAlreadyLinked:
            .providerAlreadyLinked
        case .credentialAlreadyInUse, .accountExistsWithDifferentCredential:
            .credentialAlreadyInUse
        case .networkError:
            .networkError
        case .tooManyRequests:
            .tooManyRequests
        default:
            .unknown
        }
    }
}
