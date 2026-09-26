//
//  RootCoordinator+SheetEventMatcher.swift
//  Vexta
//
//  Created by MaxAdmin on 26.09.2026.
//

import Foundation

// MARK: - Feature imports
import FeaturePurchase

extension RootCoordinator {

    func matchSubscriptionSheetEvent(for sheetEvent: SubscriptionSheetStore.SheetEvent) {
        switch sheetEvent {

        case .checkUserPremiumSucceeded: break

        case .checkUserPremiumFailed(let error):
            let purchaseAlert = alertFactory.makeAlert(for: error)
            send(.presentedAlert(purchaseAlert))
        }
    }
}
