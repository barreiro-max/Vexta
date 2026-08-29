//
//  SendResetPasswordUseCase.swift
//  FeatureAuth
//
//  Created by MaxAdmin on 27.08.2026.
//

import Foundation
import Domain

public protocol SendPasswordResetUseCase: Sendable {
    func execute(email: String) async throws(AuthError)
}

public struct SendPasswordResetUseCaseImpl {
    private let authRepository: AuthRepository

    public init(
        authRepository: AuthRepository,
    ) {
        self.authRepository = authRepository
    }
}

extension SendPasswordResetUseCaseImpl: SendPasswordResetUseCase {
    public func execute(email: String) async throws(AuthError) {
        do throws(AuthError) {
            try await authRepository.sendPasswordReset(email: email)
        } catch {
            throw error
        }
    }
}

