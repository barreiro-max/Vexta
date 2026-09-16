//
//  RootSession.swift
//  Vexta
//
//  Created by MaxAdmin on 16.09.2026.
//

import Foundation

import Domain

import FeaturePurchase

@MainActor
final class RootSession {

    // MARK: - Nested Types
    enum SessionEvent {
        case userHasPremium
        case userHasNotPremium
    }

    private let checkUserPremiumStatusUseCase: CheckUserPremiumStatusUseCase

    init(
        checkUserPremiumStatusUseCase: CheckUserPremiumStatusUseCase,
    ) {
        self.checkUserPremiumStatusUseCase = checkUserPremiumStatusUseCase
    }

    func validateUserPremiumStatus(
        onSessionEvent: @escaping @MainActor (SessionEvent) -> Void
    ) {
        Task {
            do throws(PurchaseError) {
                let status = try await checkUserPremiumStatusUseCase.execute()
                status ? onSessionEvent(.userHasPremium) : onSessionEvent(.userHasNotPremium)
            } catch {
                onSessionEvent(.userHasNotPremium)
            }
        }
    }
}
