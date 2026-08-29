//
//  FirebaseAuthDataSource.swift
//  FeatureAuth
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation
import FirebaseAuth

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

        let facebookCredential = FirebaseAuth.FacebookAuthProvider.credential(
            withAccessToken: tokens.accessToken
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

    public func signOut() throws {
        do {
            googleAuthProvider.signOut()
            facebookAuthProvider.signOut()
            try auth.signOut()
        } catch {
            throw error
        }
    }

    public func deleteUser() async throws {
        guard let user = auth.currentUser else {
            throw AuthErrorCode.userNotFound
        }

        do {
            try await user.delete()
        } catch {
            throw error
        }
    }
}
