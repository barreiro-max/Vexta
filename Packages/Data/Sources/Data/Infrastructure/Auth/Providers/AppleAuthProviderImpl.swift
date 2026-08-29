//
//  AppleAuthProviderImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation
import AuthenticationServices
import Domain
import Telemetry

public final class AppleAuthProviderImpl: NSObject, @unchecked Sendable {

    private let nonceProvider: NonceProvider
    private let topViewControllerProvider: TopViewControllerProvider

    public init(
        nonceProvider: NonceProvider,
        topViewControllerProvider: TopViewControllerProvider
    ) {
        self.nonceProvider = nonceProvider
        self.topViewControllerProvider = topViewControllerProvider
    }

    private var rawNonce: String?
    private var continuation: CheckedContinuation<AppleSignInResult, Error>?
}

extension AppleAuthProviderImpl: AppleAuthProvider {
    public func signIn() async throws -> AppleSignInResult {
        guard let topVC = topViewControllerProvider.getTopViewController() else {
            throw AppleSignInError.cannotFindTopViewController
        }

        let nonceLength = 32
        let rawNonce = nonceProvider.randomNonceString(length: nonceLength)
        let hashedNonce = nonceProvider.sha256(rawNonce)

        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce

        let authController = ASAuthorizationController(authorizationRequests: [request])

        return try await withCheckedThrowingContinuation { continuation in

            self.continuation = continuation

            authController.delegate = self
            authController.presentationContextProvider = topVC
            authController.performRequests()
        }
    }
}

extension AppleAuthProviderImpl: ASAuthorizationControllerDelegate {

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityTokenData = appleIDCredential.identityToken,
            let identityToken = String(data: identityTokenData, encoding: .utf8),
            let nonce = rawNonce
        else {
            Log.auth.error("Invalid AppleID credential")
            continuation?.resume(throwing: AppleSignInError.invalidAppleIdCredential)
            return
        }

        continuation?.resume(
            returning: AppleSignInResult(
                idToken: identityToken,
                fullName: appleIDCredential.fullName,
                nonce: nonce
            )
        )
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        Log.auth.error("Failed signed in with Apple: \(error.localizedDescription)")
        continuation?.resume(throwing: error)
    }
}

// MARK: - UIViewController + ASAuthorizationControllerPresentationContextProviding
extension UIViewController: @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}
