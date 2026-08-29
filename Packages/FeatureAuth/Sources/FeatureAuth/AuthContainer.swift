//
//  AuthContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 31.07.2026.
//

import Foundation
import Domain
import Data
import Telemetry

public final class AuthContainer {
    private let authRepository: AuthRepository
    private let analyticsTracker: AnalyticsTracker

    public init(
        authRepository: AuthRepository,
        analyticsTracker: AnalyticsTracker
    ) {
        self.authRepository = authRepository
        self.analyticsTracker = analyticsTracker
    }

    public lazy var loginUseCase       = LoginUseCaseImpl(
        authRepository: authRepository,
        analyticsTracker: analyticsTracker
    )

    public lazy var registerUseCase    = RegisterUseCaseImpl(
        authRepository: authRepository,
        analyticsTracker: analyticsTracker
    )

    public lazy var sendPasswordResetUseCase = SendPasswordResetUseCaseImpl(
        authRepository: authRepository
    )
}
