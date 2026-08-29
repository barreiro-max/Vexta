//
//  AuthErrorMapper.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation
import Domain
import FirebaseAuth

extension AuthError {

    public init(from error: any Error) {
        switch error {
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
        case .invalidSignIn, .invalidIdToken:
            .invalidCredential
        case .cannotFindTopViewController, .invalidRestorePreviousSignIn:
            .uiError
        }
    }

    private init(from appleSignInError: AppleSignInError) {
        self = switch appleSignInError {
        case .cannotFindTopViewController:
            .uiError
        case .invalidAppleIdCredential:
            .invalidCredential
        }
    }

    private init(from facebookSignInError: FacebookSignInError) {
        self = switch facebookSignInError {
        case .cannotFindTopViewController:
            .uiError
        case .invalaidCurrentNonce, .missingLoginConfiguration, .invalidAccessToken:
            .invalidCredential
        case .userCancelled:
            .userCancelled
        }
    }

    private init(from authErrorCode: AuthErrorCode?) {
        self = switch authErrorCode {
        case .userNotFound:
            .userNotFound
        case .userDisabled:
            .userDisabled
        case .networkError:
            .networkError
        case .tooManyRequests:
            .tooManyRequests
        case .invalidEmail:
            .invalidEmail
        case .wrongPassword:
            .wrongPassword
        case .emailAlreadyInUse:
            .emailAlreadyInUse
        case .credentialAlreadyInUse, .accountExistsWithDifferentCredential:
            .credentialAlreadyInUse
        case .requiresRecentLogin:
            .requiresRecentLogin
        case .invalidCredential, .invalidCustomToken:
            .invalidCredential
        default:
            .unknown
        }
    }
}
