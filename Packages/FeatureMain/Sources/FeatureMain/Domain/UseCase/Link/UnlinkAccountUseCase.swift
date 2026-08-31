//
//  UnlinkAccountUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 30.08.2026.
//

import Foundation
import Domain

public protocol UnlinkAccountUseCase: Sendable {
    func execute(from provider: LinkableAuthProviderOption) async throws(AccountError) -> String
}

public struct UnlinkAccountUseCaseImpl {
    private let accountRepository: AccountRepository

    public init(
        accountRepository: AccountRepository,
    ) {
        self.accountRepository = accountRepository
    }
}

extension UnlinkAccountUseCaseImpl: UnlinkAccountUseCase {
    public func execute(from provider: LinkableAuthProviderOption) async throws(AccountError) -> String {
        do throws(AccountError) {
            let uid = try await accountRepository.unlink(from: provider)

            return uid
        } catch {
            throw error
        }
    }
}
