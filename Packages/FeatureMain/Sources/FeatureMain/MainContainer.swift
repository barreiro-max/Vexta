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
    private let authRepository: AuthRepository
    private let analyticsTracker: AnalyticsTracker

    public init(
        authRepository: AuthRepository,
        analyticsTracker: AnalyticsTracker
    ) {
        self.authRepository = authRepository
        self.analyticsTracker = analyticsTracker
    }

    public lazy var logOutUseCase       = LogOutUseCaseImpl(
        authRepository: authRepository,
        analyticsTracker: analyticsTracker
    )
}
