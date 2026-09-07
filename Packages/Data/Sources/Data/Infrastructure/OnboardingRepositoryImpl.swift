//
//  OnboardingRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation
import Domain
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
        preferenceDataSource.set(true, forKey: preferenceKey)
        Log.onboarding.debug("Onboarding completed")
    }
}

extension UserDefaults: @unchecked Sendable {}
