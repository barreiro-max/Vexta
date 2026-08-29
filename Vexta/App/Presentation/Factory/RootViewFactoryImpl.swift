//
//  RootViewFactoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import SwiftUI

// MARK: - shared imports
import Domain
import Presentation

// MARK: - feature imports
import FeatureSplash
import FeatureAuth
import FeatureMain

@MainActor
protocol RootViewFactory {
    func makeSplashView(
        onStoreEvent: @escaping (SplashStore.Event) -> Void
    ) -> SplashView

    func makeAuthFlowView(
        onFlowEvent: @escaping (AuthFlowCoordinatorEvent) -> Void
    ) -> AuthFlowView

    func makeTabFlowView(
        onFlowEvent: @escaping (TabFlowCoordinatorEvent) -> Void
    ) -> TabFlowView
}

public struct RootViewFactoryImpl {
    private let splashViewFactory: SplashViewFactory
    private let authViewFactory: AuthViewFactory
    private let tabFlowViewFactory: TabFlowViewFactory

    init(
        splashViewFactory: SplashViewFactory,
        authViewFactory: AuthViewFactory,
        tabFlowViewFactory: TabFlowViewFactory
    ) {
        self.splashViewFactory = splashViewFactory
        self.authViewFactory = authViewFactory
        self.tabFlowViewFactory = tabFlowViewFactory
    }
}

extension RootViewFactoryImpl: RootViewFactory {
    func makeSplashView(
        onStoreEvent: @escaping (SplashStore.Event) -> Void
    ) -> SplashView {
        splashViewFactory.makeSplashView(onStoreEvent: onStoreEvent)
    }

    func makeAuthFlowView(
        onFlowEvent: @escaping (AuthFlowCoordinatorEvent) -> Void
    ) -> AuthFlowView {
        AuthFlowView(
            viewFactory: authViewFactory,
            onFlowEvent: onFlowEvent
        )
    }

    func makeTabFlowView(
        onFlowEvent: @escaping (TabFlowCoordinatorEvent) -> Void
    ) -> TabFlowView {
        TabFlowView(
            viewFactory: tabFlowViewFactory,
            onFlowEvent: onFlowEvent
        )
    }
}
