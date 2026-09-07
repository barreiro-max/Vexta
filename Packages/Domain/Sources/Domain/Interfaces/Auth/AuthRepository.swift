//
//  AuthRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 31.07.2026.
//

import Foundation

public protocol AuthRepository: Sendable {
    @MainActor func signIn(
        with provider: AuthProviderOption
    ) async throws(AuthError) -> String

    @MainActor func signUp(
        email: String,
        password: String
    ) async throws(AuthError) -> String

    func sendPasswordReset(email: String) async throws(AuthError)

    func sendEmailVerification() async throws(AuthError)
    var isEmailVerified: Bool { get async throws(AuthError) }
}
