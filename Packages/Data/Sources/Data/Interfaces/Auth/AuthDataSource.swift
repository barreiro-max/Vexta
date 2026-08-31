//
//  AuthDataSource.swift
//  Vexta
//
//  Created by MaxAdmin on 30.07.2026.
//

import Foundation

public protocol AuthDataSource: Sendable {
    func signInAnonymous() async throws -> String

    func signInEmail(email: String, password: String) async throws -> String

    func signInGoogle() async throws -> String

    func signInApple() async throws -> String

    func signInFacebook() async throws -> String

    func signUp(email: String, password: String) async throws -> String

    func sendPasswordReset(email: String) async throws

    func sendEmailVerification(email: String) async throws
    var isEmailVerified: Bool { get async throws }
}
