//
//  MainContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 24.08.2026.
//

import Foundation
import Domain
import Data
import Telemetry

public final class MainContainer {
    private let accountRepository: AccountRepository
    private let analyticsTracker: AnalyticsTracker

    public init(
        accountRepository: AccountRepository,
        analyticsTracker: AnalyticsTracker
    ) {
        self.accountRepository = accountRepository
        self.analyticsTracker = analyticsTracker
    }

    public lazy var logOutUseCase       = LogOutUseCaseImpl(
        accountRepository: accountRepository,
        analyticsTracker: analyticsTracker
    )

    public lazy var deleteAccountUseCase = DeleteAccountUseCaseImpl(
        accountRepository: accountRepository
    )

    public lazy var userAnonymousUseCase = UserAnonymousUseCaseImpl(
        accountRepository: accountRepository
    )
}
