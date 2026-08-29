//
//  LoginUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 30.07.2026.
//

import Foundation
import Domain

public protocol LoginUseCase: Sendable {
    func execute(with provider: AuthProviderOption) async throws(AuthError) -> String
}

public struct LoginUseCaseImpl {

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

extension LoginUseCaseImpl: LoginUseCase {

    public func execute(with provider: AuthProviderOption) async throws(AuthError) -> String {
        do throws(AuthError) {
            let uid = try await authRepository.signIn(with: provider)
            analyticsTracker.set(userId: uid)
            analyticsTracker.track(event: .userLoggedIn)
            return uid
        } catch {
            throw error 
        }
    }
}
