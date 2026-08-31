//
//  AccountRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 31.07.2026.
//

import Foundation

public protocol AccountRepository: Sendable {
    @MainActor func link(
        with provider: LinkableAuthProviderOption
    ) async throws(AccountError) -> String

    func unlink(
        from providerId: LinkableAuthProviderOption
    ) async throws(AccountError) -> String

    var isAnonymous: Bool { get async throws(AccountError) }

    func signOut() throws(AccountError)
    func deleteUser() async throws(AccountError)
}
