//
//  OnboardingRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation

public protocol OnboardingRepository: Sendable {
    var isPassedOnboarding: Bool { get }
    func setOnboardingPassed() throws
}
