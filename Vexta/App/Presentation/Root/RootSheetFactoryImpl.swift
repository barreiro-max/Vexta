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

protocol RootSheetFactory {
    func makeSubscriptionSheet() -> SubscriptionSheet
    func makeCustomCenterSheet() -> CustomCenterSheet
    func makeEmailVerificationSheet() -> EmailVerificationSheet

}

struct RootSheetFactoryImpl {}

extension RootSheetFactoryImpl: RootSheetFactory {

    func makeSubscriptionSheet() -> SubscriptionSheet {
        SubscriptionSheet()
    }

    func makeCustomCenterSheet() -> CustomCenterSheet {
        CustomCenterSheet()
    }

    func makeEmailVerificationSheet() -> EmailVerificationSheet {
        EmailVerificationSheet()
    }
}
