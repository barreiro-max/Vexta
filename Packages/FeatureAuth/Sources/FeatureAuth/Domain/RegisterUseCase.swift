//
//  RegisterUseCase.swift
//  FeatureAuth
//
//  Created by MaxAdmin on 27.08.2026.
//

import Foundation
import Domain

public protocol RegisterUseCase: Sendable {
    func execute(email: String, password: String) async throws(AuthError) -> String
}

public struct RegisterUseCaseImpl {
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

extension RegisterUseCaseImpl: RegisterUseCase {
    public func execute(email: String, password: String) async throws(AuthError) -> String {
        do throws(AuthError) {
            let uid = try await authRepository.signUp(
                email: email,
                password: password
            )
            
            analyticsTracker.set(userId: uid)
            analyticsTracker.track(event: .userRegistered)
            return uid
        } catch {
            throw error
        }
    }
}
