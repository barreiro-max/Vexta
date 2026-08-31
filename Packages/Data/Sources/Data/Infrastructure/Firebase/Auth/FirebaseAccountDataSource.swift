//
//  FirebaseAccountDataSource.swift
//  FeatureAuth
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation
import FirebaseAuth
import Domain
import Telemetry

public struct FirebaseAccountDataSource {

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

extension FirebaseAccountDataSource: AccountDataSource {
    public func linkWithEmail(email: String, password: String) async throws -> String {
        let emailPasswordCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        let authDataResult = try await firebaseUser.link(with: emailPasswordCredential)
        return authDataResult.user.uid
    }

    public func linkWithGoogle() async throws -> String {
        let tokens = try await googleAuthProvider.signIn()

        let gooogleCredential = FirebaseAuth.GoogleAuthProvider.credential(
            withIDToken: tokens.idToken,
            accessToken: tokens.accessToken
        )
        let authDataResult = try await firebaseUser.link(with: gooogleCredential)
        return authDataResult.user.uid
    }

    public func linkWithApple() async throws -> String {
        let tokens = try await appleAuthProvider.signIn()

        let appleCredential = OAuthProvider.appleCredential(
            withIDToken: tokens.idToken,
            rawNonce: tokens.nonce,
            fullName: tokens.fullName
        )
        let authDataResult = try await firebaseUser.link(with: appleCredential)
        return authDataResult.user.uid
    }

    public func linkWithFacebook() async throws -> String {
        let tokens = try await facebookAuthProvider.signIn()

        let facebookCredential = FirebaseAuth.FacebookAuthProvider.credential(
            withAccessToken: tokens.accessToken
        )
        let authDataResult = try await firebaseUser.link(with: facebookCredential)
        return authDataResult.user.uid
    }

    public func unlink(providerId: String) async throws -> String {
        do {
            let user = try await firebaseUser.unlink(fromProvider: providerId)
            return user.uid
        } catch {
            throw error
        }
    }

    public var isAnonymous: Bool {
        get async throws {
            do {
                // WARN: — don't use `reload()` with firebase auth emulator
                try await firebaseUser.reload()

                let isAnonymous = try firebaseUser.isAnonymous
                Log.auth.debug("User anonymous: \(isAnonymous)")
                return try isAnonymous
            } catch {
                throw error
            }
        }
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
        do {
            try await firebaseUser.delete()
        } catch {
            throw error
        }
    }

    private var firebaseUser: FirebaseAuth.User {
        get throws(AccountError) {
            guard let user = auth.currentUser else {
                throw AccountError.userNotFound
            }
            return user
        }
    }
}
