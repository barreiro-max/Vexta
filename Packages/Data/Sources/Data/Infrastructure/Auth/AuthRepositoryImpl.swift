//
//  AuthRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 04.07.2026.
//

import Foundation
import Domain
import Telemetry

public struct AuthRepositoryImpl {

    private let authDataSource: AuthDataSource

    public init(authDataSource: AuthDataSource) {
        self.authDataSource = authDataSource
    }
}

extension AuthRepositoryImpl: AuthRepository {

    @MainActor
    public func signIn(with provider: AuthProviderOption) async throws(AuthError) -> String {
        do {
            let userUID = switch provider {

            case .anonymous:
                try await authDataSource.signInAnonymous()

            case .email(let email, let password):
                try await authDataSource.signInEmail(
                    email: email,
                    password: password
                )

            case .google:
                try await authDataSource.signInGoogle()

            case .apple:
                try await authDataSource.signInApple()

            case .facebook:
                try await authDataSource.signInFacebook()
            }

            Log.auth.notice("Successfully signed in into Firebase with \(provider.title) provider")

            return userUID
        } catch {
            let authError = AuthError(from: error)

            throw authError
        }
    }

    public func signUp(email: String, password: String) async throws(AuthError) -> String {
        do {
            let userUID = try await authDataSource.signUp(
                email: email,
                password: password
            )
            Log.auth.notice("Successfully signed Up into Firebase with \(email)")

            return userUID
        } catch {
            let authError = AuthError(from: error)

            throw authError
        }
    }

    public func sendPasswordReset(email: String) async throws(AuthError) {
        do {
            try await authDataSource.sendPasswordReset(email: email)
            Log.auth.notice("Successfully sent password reset in: \(email) from Firebase")
        } catch {
            let authError = AuthError(from: error)

            throw authError
        }
    }

    public func sendEmailVerification() async throws(AuthError) {
        do {
            try await authDataSource.sendEmailVerification()
            Log.auth.notice("Successfully sent email verification from Firebase")
        } catch {
            let authError = AuthError(from: error)

            throw authError
        }
    }

    public var isEmailVerified: Bool {
        get async throws(AuthError) {
            do {
                let isEmailVerified = try await authDataSource.isEmailVerified
                Log.auth.notice("User email verified: \(isEmailVerified)")
                return isEmailVerified
            } catch {
                let authError = AuthError(from: error)
                
                throw authError
            }
        }
    }
}
