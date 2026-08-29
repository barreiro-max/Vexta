//
//  DeleteAccountUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 27.08.2026.
//

import Foundation
import Domain

public protocol DeleteAccountUseCase {
    func execute() async throws(AuthError)
}

public struct DeleteAccountUseCaseImpl {
    private let authRepository: AuthRepository

    public init(
        authRepository: AuthRepository,
    ) {
        self.authRepository = authRepository
    }
}

extension DeleteAccountUseCaseImpl: DeleteAccountUseCase {
    public func execute() async throws(AuthError) {
        do throws(AuthError) {
            try await authRepository.deleteUser()
        } catch {
            throw error
        }
    }
}
