//
//  AuthErrorMapper.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation
import Domain
import FirebaseAuth
import AuthenticationServices

extension AuthError {

    public init(from error: any Error) {
        switch error {

        case let auhtError as AuthError:
            self = auhtError

        case let googleSignInError as GoogleSignInError:
            self.init(from: googleSignInError)

        case let appleSignInError as AppleSignInError:
            self.init(from: appleSignInError)

        case let facebookSignInError as FacebookSignInError:
            self.init(from: facebookSignInError)

        case let appleAuthError as ASAuthorizationError:
            self.init(from: appleAuthError)

        case let nsError as NSError where nsError.domain == AuthErrorDomain:
            guard let authErrorCode = AuthErrorCode(rawValue: nsError.code) else {
                self = .unknown(underlying: nsError)
                return
            }
            self.init(from: authErrorCode)

        default:
            self = .unknown(underlying: error as NSError)
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
        case .invalidCurrentNonce, .missingLoginConfiguration, .invalidAuthToken:
            .invalidCredential
        case .userCancelled:
            .userCancelled
        }
    }

    private init(from appleAuthError: ASAuthorizationError) {
        switch appleAuthError.code {
        case .canceled:
            self = .userCancelled
        case .notInteractive:
            self = .uiError
        default:
            let nsError = appleAuthError as NSError
            let customNSError = NSError(
                domain: nsError.domain,
                code: nsError.code,
                userInfo: [
                    NSLocalizedDescriptionKey: "Sign In with Apple is not configured (not set capabilities)"
                ]
            )
            self = .unknown(underlying: customNSError)
        }
    }

    private init(from authErrorCode: AuthErrorCode) {
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
        case .missingEmail:
            .missingEmail
        case .wrongPassword:
            .wrongPassword
        case .emailAlreadyInUse:
            .emailAlreadyInUse
        case .accountExistsWithDifferentCredential:
            .accountExistsWithDifferentCredential
        case .credentialAlreadyInUse:
            .credentialAlreadyInUse
        case .requiresRecentLogin:
            .requiresRecentLogin
        case .invalidCredential, .invalidCustomToken:
            .invalidCredential
        default:
            .unknown(underlying: authErrorCode as NSError)
        }
    }
}
