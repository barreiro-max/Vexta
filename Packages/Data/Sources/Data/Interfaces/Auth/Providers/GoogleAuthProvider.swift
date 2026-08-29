//
//  GoogleAuthProvider.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation
import Domain

public protocol GoogleAuthProvider: Sendable {
    @MainActor func signIn() async throws -> GoogleSignInResult
    func signOut()
}
