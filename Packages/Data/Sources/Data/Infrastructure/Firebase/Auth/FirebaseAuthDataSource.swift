//
//  FirebaseAuthDataSource.swift
//  FeatureAuth
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation
import FirebaseAuth
import Domain
import Telemetry
import Environment

public struct FirebaseAuthDataSource {

    private let googleAuthProvider: GoogleAuthProvider
    private let appleAuthProvider: AppleAuthProvider
    private let facebookAuthProvider: FacebookAuthProvider

    private var auth: Auth {
        Auth.auth()
    }

    public init(
        googleAuthProvider: GoogleAuthProvider,
        appleAuthProvider: AppleAuthProvider,
        facebookAuthProvider: FacebookAuthProvider
    ) {
        self.googleAuthProvider = googleAuthProvider
        self.appleAuthProvider = appleAuthProvider
        self.facebookAuthProvider = facebookAuthProvider
    }
}

extension FirebaseAuthDataSource: AuthDataSource {

    public func signInAnonymous() async throws -> String {
        let authDataResult = try await auth.signInAnonymously()
        return authDataResult.user.uid
    }

    public func signInEmail(email: String, password: String) async throws -> String {
        let authDataResult = try await auth.signIn(
            withEmail: email,
            password: password
        )
        return authDataResult.user.uid
    }

    public func signInGoogle() async throws -> String {
        let tokens = try await googleAuthProvider.signIn()

        let gooogleCredential = FirebaseAuth.GoogleAuthProvider.credential(
            withIDToken: tokens.idToken,
            accessToken: tokens.accessToken
        )
        let authDataResult = try await auth.signIn(with: gooogleCredential)
        return authDataResult.user.uid
    }

    public func signInApple() async throws -> String {
        let tokens = try await appleAuthProvider.signIn()

        let appleCredential = OAuthProvider.appleCredential(
            withIDToken: tokens.idToken,
            rawNonce: tokens.nonce,
            fullName: tokens.fullName
        )
        let authDataResult = try await auth.signIn(with: appleCredential)
        return authDataResult.user.uid
    }

    public func signInFacebook() async throws -> String {
        let tokens = try await facebookAuthProvider.signIn()

        let facebookCredential = OAuthProvider.credential(
            providerID: .facebook,
            idToken: tokens.authToken,
            rawNonce: tokens.nonce
        )
        let authDataResult = try await auth.signIn(with: facebookCredential)
        return authDataResult.user.uid
    }

    public func signUp(email: String, password: String) async throws -> String {
        let authDataResult = try await auth.createUser(
            withEmail: email,
            password: password
        )
        return authDataResult.user.uid
    }

    public func sendPasswordReset(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }

    public func sendEmailVerification() async throws {
        try await firebaseUser.sendEmailVerification()
    }

    public var isEmailVerified: Bool {
        get async throws {
            do {
                guard !EnvironmentVariables.isUseFirebaseEmulator else {
                    preconditionFailure("Don't use `User.reload` with firebase auth emulator")
                }
                try await firebaseUser.reload()

                let isEmailVerified = try firebaseUser.isEmailVerified
                return isEmailVerified
            } catch {
                throw error
            }
        }
    }

    private var firebaseUser: FirebaseAuth.User {
        get throws(AuthError) {
            guard let user = auth.currentUser else {
                throw AuthError.userNotFound
            }
            return user
        }
    }
}
