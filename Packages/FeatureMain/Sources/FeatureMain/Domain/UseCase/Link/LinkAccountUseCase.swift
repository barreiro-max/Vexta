//
//  LinkAccountUseCaseImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 30.08.2026.
//

import Foundation
import Domain

public protocol LinkAccountUseCase: Sendable {
    func execute(with provider: LinkableAuthProviderOption) async throws(AccountError) -> String
}

public struct LinkAccountUseCaseImpl {
    private let accountRepository: AccountRepository

    public init(
        accountRepository: AccountRepository,
    ) {
        self.accountRepository = accountRepository
    }
}

extension LinkAccountUseCaseImpl: LinkAccountUseCase {
    public func execute(with provider: LinkableAuthProviderOption) async throws(AccountError) -> String {
        do throws(AccountError) {
            let uid = try await accountRepository.link(with: provider)

            return uid
        } catch {
            throw error
        }
    }
}
