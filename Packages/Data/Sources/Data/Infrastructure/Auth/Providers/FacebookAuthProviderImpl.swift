//
//  FacebookAuthProviderImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation
import Telemetry
import Domain
import FacebookLogin

public final class FacebookAuthProviderImpl: Sendable {
    private var facebookLoginManager: LoginManager {
        LoginManager()
    }

    private let nonceProvider: NonceProvider
    private let topViewControllerProvider: TopViewControllerProvider

    public init(
        nonceProvider: NonceProvider,
        topViewControllerProvider: TopViewControllerProvider
    ) {
        self.nonceProvider = nonceProvider
        self.topViewControllerProvider = topViewControllerProvider
    }

    @MainActor private var rawNonce: String?
    @MainActor private var continuation: CheckedContinuation<FacebookSignInResult, Error>?
}

extension FacebookAuthProviderImpl: FacebookAuthProvider {
    @MainActor
    public func signIn() async throws -> FacebookSignInResult {
        guard let topVC = topViewControllerProvider.getTopViewController() else {
            throw FacebookSignInError.cannotFindTopViewController
        }

        let nonceLength = 32
        let nonce = nonceProvider.randomNonceString(length: nonceLength)
        let hashedNonce = nonceProvider.sha256(nonce)
        self.rawNonce = nonce

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            guard let config = LoginConfiguration(
                permissions: ["public_profile", "email"],
                tracking: .limited,
                nonce: hashedNonce,
            ) else {
                Log.auth.error("Missing Facebook Login confuguration")
                continuation.resume(throwing: FacebookSignInError.missingLoginConfiguration)
                return
            }

            facebookLoginManager.logIn(viewController: topVC, configuration: config) { result in self.matchLoginResult(with: continuation, by: result)
            }
        }
    }

    @MainActor private func matchLoginResult(
        with continuation: CheckedContinuation<FacebookSignInResult, Error>,
        by result: LoginResult
    ) {
        switch result {

        case let .success(granted, declined, _):

            Log.auth.debug("Facebook Permissions, granted: \(granted), declined: \(declined)")

            guard let authToken = AuthenticationToken.current else {
                Log.auth.error("Facebook AuthenticationToken is nil")
                continuation.resume(throwing: FacebookSignInError.invalidAuthToken)
                return
            }

            guard let nonce = rawNonce else {
                Log.auth.error("Facebook current nonce is nil")
                continuation.resume(throwing: FacebookSignInError.invalidCurrentNonce)
                return
            }

            continuation.resume(
                returning: FacebookSignInResult(
                    authToken: authToken.tokenString,
                    nonce: nonce
                )
            )

        case .cancelled:
            Log.auth.info("Facebook Login cancelled by user")
            continuation.resume(throwing: FacebookSignInError.userCancelled)

        case let .failed(error):
            Log.auth.error("Facebook Login Error: \(error.localizedDescription)")
            continuation.resume(throwing: error)
        }
    }

    public func signOut() {
        facebookLoginManager.logOut()
        Log.auth.info("Facebook user signed out")
    }
}
