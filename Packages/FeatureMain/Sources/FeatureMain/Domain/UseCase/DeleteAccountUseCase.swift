//
//  DeleteAccountUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 27.08.2026.
//

import Foundation
import Domain

public protocol DeleteAccountUseCase: Sendable {
    func execute() async throws(AccountError)
}

public struct DeleteAccountUseCaseImpl {
    private let accountRepository: AccountRepository

    public init(
        accountRepository: AccountRepository,
    ) {
        self.accountRepository = accountRepository
    }
}

extension DeleteAccountUseCaseImpl: DeleteAccountUseCase {
    public func execute() async throws(AccountError) {
        do throws(AccountError) {
            try await accountRepository.deleteUser()
        } catch {
            throw error
        }
    }
}
