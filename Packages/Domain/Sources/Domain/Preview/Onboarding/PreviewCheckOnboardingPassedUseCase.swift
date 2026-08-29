//
//  PreviewCheckOnboardingPassedUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation

public struct PreviewCheckOnboardingPassedUseCase: CheckOnboardingPassedUseCase {

    public let isPassed: Bool

    public init(isPassed: Bool) {
        self.isPassed = isPassed
    }

    public func execute() -> Bool {
        isPassed
    }
}
