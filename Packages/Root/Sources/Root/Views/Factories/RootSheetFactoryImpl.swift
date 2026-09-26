//
//  RootSheetFactoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 27.08.2026.
//

import SwiftUI

// MARK: - Shared imports
import Presentation

// MARK: - Feature imports
import FeaturePurchase
import FeatureAuth

@MainActor
protocol RootSheetFactory {
    func makeSubscriptionSheet(
        onStoreSheetEvent: @escaping (SubscriptionSheetStore.SheetEvent) -> Void
    ) -> SubscriptionSheet
    func makeCustomerCenterSheet() -> CustomerCenterSheet
    func makeEmailVerificationSheet() -> EmailVerificationSheet

}

@MainActor
struct RootSheetFactoryImpl {

    private let checkUserPremiumStatusUseCase: CheckUserPremiumStatusUseCase

    init(checkUserPremiumStatusUseCase: CheckUserPremiumStatusUseCase) {
        self.checkUserPremiumStatusUseCase = checkUserPremiumStatusUseCase
    }
}

extension RootSheetFactoryImpl: RootSheetFactory {

    func makeSubscriptionSheet(
        onStoreSheetEvent: @escaping (SubscriptionSheetStore.SheetEvent) -> Void
    ) -> SubscriptionSheet {
        let sheetStore = SubscriptionSheetStore(
            checkUserPremiumStatusUseCase: checkUserPremiumStatusUseCase,
            onStoreSheetEvent: onStoreSheetEvent
        )
        return SubscriptionSheet(sheetStore: sheetStore)
    }

    func makeCustomerCenterSheet() -> CustomerCenterSheet {
        CustomerCenterSheet()
    }

    func makeEmailVerificationSheet() -> EmailVerificationSheet {
        EmailVerificationSheet()
    }
}
