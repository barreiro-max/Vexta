//
//  PurchaseContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 23.08.2026.
//

import Foundation

public final class PurchaseContainer {
    public init() {}

    lazy var purchaseProvider = RevenueCatProvider()

    public lazy var checkUserPremiumStatusUseCase = CheckUserPremiumStatusUseCaseImpl(
        purchaseProvider: purchaseProvider
    )
}
