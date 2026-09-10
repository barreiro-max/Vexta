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
    func makeSubcriptionSheet() -> EmptyView
    func makeEmailVerificationSheet() -> EmailVerificationSheet

}

struct RootSheetFactoryImpl {}

extension RootSheetFactoryImpl: RootSheetFactory {
    func makeSubcriptionSheet() -> EmptyView {
        EmptyView()
    }

    func makeEmailVerificationSheet() -> EmailVerificationSheet {
        EmailVerificationSheet()
    }
}
