//
//  RootAlertFactoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 10.08.2026.
//

import Foundation

// MARK: - Shared imports
import Domain
import Presentation
import Notification

// MARK: - Feature imports
import FeatureSplash
import FeatureMain
import FeaturePurchase

@MainActor
protocol RootAlertFactory: Sendable {
    func makeAlert(for error: LocalizedError) -> AppAlert

    func makeRetryAlert(
        for error: LocalizedError,
        onRetry: @escaping @MainActor () async -> Void
    ) -> AppAlert
}

struct RootAlertFactoryImpl {}

extension RootAlertFactoryImpl: RootAlertFactory  {
    func makeAlert(for error: LocalizedError) -> AppAlert {
        AppAlert(error: error)
    }

    func makeRetryAlert(
        for error: LocalizedError,
        onRetry: @escaping @MainActor () async -> Void
    ) -> AppAlert {
        AppAlert(
            error: error,
            buttonActions: [.retry(onAction: onRetry)]
        )
    }
}
