//
//  SendEmailVerificationUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 30.07.2026.
//

import Foundation
import Domain

public protocol SendEmailVerificationUseCase: Sendable {
    func execute() async throws(AuthError)
}

public struct SendEmailVerificationUseCaseImpl {

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

extension SendEmailVerificationUseCaseImpl: SendEmailVerificationUseCase {

    public func execute() async throws(AuthError) {
        do throws(AuthError) {
            try await authRepository.sendEmailVerification()
            analyticsTracker.track(event: .emailVerificationSent)
        } catch {
            throw error
        }
    }
}
