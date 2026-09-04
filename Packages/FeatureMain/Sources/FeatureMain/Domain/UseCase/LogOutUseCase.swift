//
//  LogOutUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 23.08.2026.
//

import Foundation
import Domain

public protocol LogOutUseCase: Sendable {
    func execute() async throws(AccountError)
}

public struct LogOutUseCaseImpl {

    private let accountRepository: AccountRepository
    private let analyticsTracker: AnalyticsTracker

    public init(
        accountRepository: AccountRepository,
        analyticsTracker: AnalyticsTracker
    ) {
        self.accountRepository = accountRepository
        self.analyticsTracker = analyticsTracker
    }
}

extension LogOutUseCaseImpl: LogOutUseCase {

    public func execute() async throws(AccountError) {
        do throws(AccountError) {
            let isAnonymous = try await accountRepository.isAnonymous

            if isAnonymous {
                try await accountRepository.deleteUser()
            } else {
                try accountRepository.signOut()
                analyticsTracker.track(event: .userLoggedOut)
            }

        } catch {
            throw error
        }
    }
}
