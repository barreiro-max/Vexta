//
//  RootSheetFactoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 27.08.2026.
//

import SwiftUI

// MARK: - shared imports
import Presentation

// MARK: - feature imports
import FeaturePurchase

protocol RootSheetFactory {
    func makeSubcriptionSheet() -> EmptyView
}

struct RootSheetFactoryImpl {}

extension RootSheetFactoryImpl: RootSheetFactory {
    func makeSubcriptionSheet() -> EmptyView {
        EmptyView()
    }
}
