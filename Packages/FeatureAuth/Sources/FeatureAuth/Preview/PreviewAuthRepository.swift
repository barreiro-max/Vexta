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

    func sendPasswordReset(email: String) async throws(AuthError) {}

    func signOut() throws(AuthError) {}

    func deleteUser() async throws(AuthError) {}
}
