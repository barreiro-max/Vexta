//
//  CompleteOnboardingUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation

public protocol CompleteOnboardingUseCase: Sendable {
    func execute() throws
}

public struct CompleteOnboardingUseCaseImpl {
    private let onboardingRepository: OnboardingRepository

    public init(onboardingRepository: OnboardingRepository) {
        self.onboardingRepository = onboardingRepository
    }
}

extension CompleteOnboardingUseCaseImpl: CompleteOnboardingUseCase {
    public func execute() throws {
        try onboardingRepository.setOnboardingPassed()
    }
}

