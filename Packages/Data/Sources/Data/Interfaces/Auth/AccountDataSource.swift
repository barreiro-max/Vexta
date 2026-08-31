//
//  AccountDataSource.swift
//  Vexta
//
//  Created by MaxAdmin on 30.07.2026.
//

import Foundation

public protocol AccountDataSource: Sendable {
    func linkWithEmail(email: String, password: String) async throws -> String

    func linkWithGoogle() async throws -> String

    func linkWithApple() async throws -> String

    func linkWithFacebook() async throws -> String

    func unlink(providerId: String) async throws -> String

    var isAnonymous: Bool { get async throws }

    func signOut() throws

    func deleteUser() async throws
}
