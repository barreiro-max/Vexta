//
//  RootAlertFactoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 10.08.2026.
//

import Foundation

// MARK: - shared imports
import Domain
import Presentation

// MARK: - feature imports
import FeatureSplash
import FeatureMain

@MainActor
protocol RootAlertFactory {
    func makeSplashAlert(
        with error: SplashError,
        onRetry: @escaping @MainActor () async -> Void
    ) -> AppAlert
    func makeAuthAlert(with error: AuthError) -> AppAlert
    func makeMainAlert(with error: MainError) -> AppAlert
}

struct RootAlertFactoryImpl {}

extension RootAlertFactoryImpl: RootAlertFactory {
    func makeSplashAlert(
        with error: SplashError,
        onRetry: @escaping @MainActor () async -> Void
    ) -> AppAlert {
        AppAlert(
            error: error,
            buttonActions: [.retry(onAction: onRetry)]
        )
    }

    func makeAuthAlert(with error: AuthError) -> AppAlert {
        AppAlert(error: error)
    }

    func makeMainAlert(with error: MainError) -> AppAlert {
        AppAlert(error: error)
    }
}
