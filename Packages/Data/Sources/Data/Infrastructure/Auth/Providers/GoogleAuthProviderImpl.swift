//
//  GoogleAuthProviderImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation
import Telemetry
import Domain
import GoogleSignIn

public struct GoogleAuthProviderImpl {
    private var gidSignIn: GIDSignIn {
        GIDSignIn.sharedInstance
    }

    private let topViewControllerProvider: TopViewControllerProvider

    public init(topViewControllerProvider: TopViewControllerProvider) {
        self.topViewControllerProvider = topViewControllerProvider
    }
}

extension GoogleAuthProviderImpl: GoogleAuthProvider {

    @MainActor public func signIn() async throws -> GoogleSignInResult {
        let result: GoogleSignInResult

        if gidSignIn.hasPreviousSignIn() {
            result = try await googleRestorePreviousSignIn()
            Log.auth.notice("Google User restored previous sign in")
        } else {
            result = try await googleSignIn()
            Log.auth.notice("Google User signed in")
        }
        return result
    }

    private func googleRestorePreviousSignIn() async throws -> GoogleSignInResult {
        do {
            let googleUser = try await gidSignIn.restorePreviousSignIn()

            guard let idToken = googleUser.idToken?.tokenString else {
                throw GoogleSignInError.invalidIdToken
            }

            let accessToken = googleUser.accessToken.tokenString

            return GoogleSignInResult(idToken: idToken, accessToken: accessToken)
        } catch {
            Log.auth.error("Google Sign in error: \(error.localizedDescription)")
            throw GoogleSignInError.invalidRestorePreviousSignIn
        }
    }

    @MainActor private func googleSignIn() async throws -> GoogleSignInResult {
        guard let topVC = topViewControllerProvider.getTopViewController() else {
            throw GoogleSignInError.cannotFindTopViewController
        }

        do {
            let signInResult = try await gidSignIn.signIn(withPresenting: topVC)

            let googleUser = signInResult.user

            guard let idToken = googleUser.idToken?.tokenString else {
                throw GoogleSignInError.invalidIdToken
            }

            let accessToken = googleUser.accessToken.tokenString

            return GoogleSignInResult(idToken: idToken, accessToken: accessToken)
        } catch {
            Log.auth.error("Google Sign in error: \(error.localizedDescription)")
            throw GoogleSignInError.invalidSignIn
        }
    }

    public func signOut() {
        gidSignIn.signOut()
        Log.auth.debug("Google user signed out")
    }
}
