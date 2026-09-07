//
//  PreviewAuthRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import Foundation
import Domain
import Telemetry

struct PreviewAuthRepository: AuthRepository {

    func signIn(with provider: AuthProviderOption) async throws(AuthError) -> String {
        return "Test signIn UUID"
    }
    
    func signUp(email: String, password: String) async throws(AuthError) -> String {
        return "Test signUp UUID"
    }

    func link(with provider: LinkableAuthProviderOption) async throws(AuthError) -> String {
        return "Test link UUID"
    }

    func sendPasswordReset(email: String) async throws(AuthError) {}
    func sendEmailVerification() async throws(AuthError) {}

    var isEmailVerified: Bool { true }
    var isAnonymous: Bool { true }

    func signOut() throws(AuthError) {}

    func unlink(from provider: LinkableAuthProviderOption) async throws(AuthError) -> String {
        return "Test unlink UUID"
    }

    func deleteUser() async throws(AuthError) {}
}
