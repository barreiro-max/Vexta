//
//  AccountErrorMapper.swift
//  Vexta
//
//  Created by MaxAdmin on 31.08.2026.
//

import Foundation
import Domain
import FirebaseAuth
import AuthenticationServices

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
        case .invalidCurrentNonce, .missingLoginConfiguration, .invalidAuthToken:
            .invalidCredentials
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
        case .requiresRecentLogin:
            .requiresRecentLogin
        case .providerAlreadyLinked:
            .providerAlreadyLinked
        case .missingEmail:
            .missingEmail
        case .invalidEmail:
            .invalidEmail
        case .noSuchProvider:
            .noSuchProvider
        case .credentialAlreadyInUse, .accountExistsWithDifferentCredential, .emailAlreadyInUse:
            .credentialAlreadyInUse
        case .networkError:
            .networkError
        case .tooManyRequests:
            .tooManyRequests
        default:
            .unknown(underlying: authErrorCode as NSError)
        }
    }
}
