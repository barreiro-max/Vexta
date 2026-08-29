//
//  FacebookAuthProvider.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation
import Domain

public protocol FacebookAuthProvider: Sendable {
    @MainActor func signIn() async throws -> FacebookSignInResult
    func signOut()
}
