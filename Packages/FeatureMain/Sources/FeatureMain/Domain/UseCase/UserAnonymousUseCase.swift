//
//  UserAnonymousUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 30.07.2026.
//

import Foundation
import Domain

public protocol UserAnonymousUseCase: Sendable {
    func execute() async throws(AccountError) -> Bool
}

public struct UserAnonymousUseCaseImpl {

    private let accountRepository: AccountRepository

    public init(
        accountRepository: AccountRepository
    ) {
        self.accountRepository = accountRepository
    }
}

extension UserAnonymousUseCaseImpl: UserAnonymousUseCase {

    public func execute() async throws(AccountError) -> Bool {
        do throws(AccountError) {
            let isAnonymous = try await accountRepository.isAnonymous
            return isAnonymous
        } catch {
            throw error
        }
    }
}
