//
//  CheckOnboardingPassedUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation

public protocol CheckOnboardingPassedUseCase: Sendable {
    func execute() -> Bool
}

public struct CheckOnboardingPassedUseCaseImpl {
    private let onboardingRepository: OnboardingRepository

    public init(onboardingRepository: OnboardingRepository) {
        self.onboardingRepository = onboardingRepository
    }
}

extension CheckOnboardingPassedUseCaseImpl: CheckOnboardingPassedUseCase {

    public func execute() -> Bool {
        onboardingRepository.isPassedOnboarding
    }
}
