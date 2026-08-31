//
//  AccountRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 04.07.2026.
//

import Foundation
import Domain
import Telemetry

public struct AccountRepositoryImpl {

    private let accountDataSource: AccountDataSource

    public init(accountDataSource: AccountDataSource) {
        self.accountDataSource = accountDataSource
    }
}

extension AccountRepositoryImpl: AccountRepository {

    @MainActor
    public func link(with provider: LinkableAuthProviderOption) async throws(AccountError) -> String {
        do {
            let userUID = switch provider {

            case .email(let email, let password):
                try await accountDataSource.linkWithEmail(
                    email: email,
                    password: password
                )

            case .google:
                try await accountDataSource.linkWithGoogle()

            case .apple:
                try await accountDataSource.linkWithApple()

            case .facebook:
                try await accountDataSource.linkWithFacebook()
            }

            Log.auth.notice("Successfully linked \(provider) to firebase user")

            return userUID
        } catch {
            let accountError = AccountError(from: error)

            throw accountError
        }
    }

    public func unlink(from provider: LinkableAuthProviderOption) async throws(AccountError) -> String {
        do {
            let domain = provider.domain
            let userUID = try await accountDataSource.unlink(providerId: domain)
            Log.auth.notice("Successfully unlinked from firebase providerId: \(domain)")

            return userUID
        } catch {
            let accountError = AccountError(from: error)

            throw accountError
        }
    }

    public var isAnonymous: Bool {
        get async throws(AccountError) {
            do {
                let isAnonymous = try await accountDataSource.isAnonymous
                Log.auth.debug("User anonymous: \(isAnonymous)")
                return isAnonymous
            } catch {
                let accountError = AccountError(from: error)

                throw accountError
            }
        }
    }

    public func signOut() throws(AccountError) {
        do {
            try accountDataSource.signOut()
            Log.auth.notice("Successfully signed out from Firebase")
        } catch {
            let accountError = AccountError(from: error)

            throw accountError
        }
    }

    public func deleteUser() async throws(AccountError) {
        do {
            try await accountDataSource.deleteUser()
            Log.auth.notice("Account deleted from firebase")
        } catch {
            let accountError = AccountError(from: error)

            throw accountError
        }
    }
}


