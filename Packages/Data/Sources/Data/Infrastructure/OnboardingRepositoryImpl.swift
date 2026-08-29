//
//  OnboardingRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation
import Domain
import Environment
import Telemetry

public struct OnboardingRepositoryImpl {

    private let preferenceDataSource: UserDefaults
    private let preferenceKey: String

    public init(
        preferenceDataSource: UserDefaults,
        preferenceKey: String
    ) {
        self.preferenceDataSource = preferenceDataSource
        self.preferenceKey = preferenceKey
    }
}

extension OnboardingRepositoryImpl: OnboardingRepository {
    public var isPassedOnboarding: Bool {
        let status = preferenceDataSource.bool(forKey: preferenceKey)
        Log.onboarding.debug("Current onboarding status: \(status)")
        return status
    }

    public func setOnboardingPassed() throws {
        switch AppEnvironment.current {
        case .prod:
            Log.onboarding.debug("Onboarding completed")
            preferenceDataSource.set(true, forKey: preferenceKey)
        default:
            Log.onboarding.debug("[DEBUG] Onboarding completed (without setting value)")
            return
        }
    }
}

extension UserDefaults: @unchecked Sendable {}
