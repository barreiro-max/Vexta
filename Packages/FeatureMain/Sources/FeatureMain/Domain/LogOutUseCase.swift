//
//  LogOutUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 23.08.2026.
//

import Foundation
import Domain

public protocol LogOutUseCase: Sendable {
    func execute() throws(AuthError)
}

public struct LogOutUseCaseImpl {

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

extension LogOutUseCaseImpl: LogOutUseCase {

    public func execute() throws(AuthError) {
        do throws(AuthError) {
            try authRepository.signOut()
            analyticsTracker.track(event: .userLoggedOut)
        } catch {
            throw error
        }
    }
}
