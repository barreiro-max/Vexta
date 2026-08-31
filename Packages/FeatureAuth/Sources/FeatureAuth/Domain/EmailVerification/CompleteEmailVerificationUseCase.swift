//
//  CompleteEmailVerificationUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 30.07.2026.
//

import Foundation
import Domain

public protocol CompleteEmailVerificationUseCase: Sendable {
    func execute() async throws(AuthError) -> Bool
}

public struct CompleteEmailVerificationUseCaseImpl {

    private let authRepository: AuthRepository
    private let analyticsTracker: AnalyticsTracker

    public init(
        authRepository: AuthRepository,
        analyticsTracker: AnalyticsTracker
    ) {
        self.authRepository = authRepository
        self.analyticsTracker = analyticsTracker
    }
}

extension CompleteEmailVerificationUseCaseImpl: CompleteEmailVerificationUseCase {

    public func execute() async throws(AuthError) -> Bool {
        do throws(AuthError) {
            let isVerified = try await authRepository.isEmailVerified

            if isVerified {
                analyticsTracker.track(event: .emailVerificationCompleted)
            }

            return isVerified
        } catch {
            throw error
        }
    }
}
