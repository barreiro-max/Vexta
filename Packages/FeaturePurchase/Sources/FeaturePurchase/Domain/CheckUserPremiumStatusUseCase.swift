//
//  CheckUserPremiumStatusUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//

import Foundation

public protocol CheckUserPremiumStatusUseCase: Sendable {
    func execute() async throws(PurchaseError) -> Bool
}

public struct CheckUserPremiumStatusUseCaseImpl {
    private let purchaseProvider: PurchaseProvider

    init(purchaseProvider: PurchaseProvider) {
        self.purchaseProvider = purchaseProvider
    }
}

extension CheckUserPremiumStatusUseCaseImpl: CheckUserPremiumStatusUseCase {

    public func execute() async throws(PurchaseError) -> Bool {
        do throws(PurchaseError) {
            return try await purchaseProvider.hasPremium
        } catch {
            throw .customerInfoNotFound
        }
    }
}
