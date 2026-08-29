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

public final class FacebookAuthProviderImpl: @unchecked Sendable {
    private var facebookLoginManager: LoginManager {
        LoginManager.makeOpener()
    }

    private let topViewControllerProvider: TopViewControllerProvider

    public init(topViewControllerProvider: TopViewControllerProvider) {
        self.topViewControllerProvider = topViewControllerProvider
    }

    private var continuation: CheckedContinuation<FacebookSignInResult, Error>?
}

extension FacebookAuthProviderImpl: FacebookAuthProvider {
    @MainActor
    public func signIn() async throws -> FacebookSignInResult {
        guard let topVC = topViewControllerProvider.getTopViewController() else {
            throw FacebookSignInError.cannotFindTopViewController
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            guard let config = limitedLoginConfiguration else {
                Log.auth.error("Missing Facebook Login confuguration")
                continuation.resume(throwing: FacebookSignInError.missingLoginConfiguration)
                return
            }

            facebookLoginManager.logIn(viewController: topVC, configuration: config) { result in self.matchLoginResult(with: continuation, by: result)
            }
        }
    }

    private var limitedLoginConfiguration: LoginConfiguration? {
        LoginConfiguration(
            permissions: ["public_profile", "email"],
            tracking: .limited
        )
    }

    private func matchLoginResult(
        with continuation: CheckedContinuation<FacebookSignInResult, Error>,
        by result: LoginResult
    ) {
        switch result {

        case let .success(_, _, accessToken):

            guard let accessTokenString = accessToken?.tokenString else {
                Log.auth.error("Facebook AccessToken is nil")
                continuation.resume(throwing: FacebookSignInError.invalidAccessToken)
                return
            }
            continuation.resume(
                returning: FacebookSignInResult(accessToken: accessTokenString)
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
