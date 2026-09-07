//
//  RootViewFactoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import SwiftUI

// MARK: - Shared imports
import Domain
import Presentation

// MARK: - Feature imports
import FeatureSplash
import FeatureOnboarding
import FeatureAuth
import FeatureMain

@MainActor
protocol RootViewFactory {
    func makeSplashView(
        onStoreEvent: @escaping (SplashStore.Event) -> Void
    ) -> SplashView

    func makeOnboardingFlowView(
        onFlowEvent: @escaping (OnboardingFlowCoordinator.FlowEvent) -> Void
    ) -> OnboardingFlowView

    func makeAuthFlowView(
        onFlowEvent: @escaping (AuthFlowCoordinator.FlowEvent) -> Void
    ) -> AuthFlowView

    func makeTabFlowView(
        onFlowEvent: @escaping (TabFlowCoordinator.FlowEvent) -> Void
    ) -> TabFlowView
}

struct RootViewFactoryImpl {
    private let onboardingViewFactory: OnboardingViewFactory
    private let splashViewFactory: SplashViewFactory
    private let authViewFactory: AuthViewFactory
    private let tabFlowViewFactory: TabFlowViewFactory

    init(
        onboardingViewFactory: OnboardingViewFactory,
        splashViewFactory: SplashViewFactory,
        authViewFactory: AuthViewFactory,
        tabFlowViewFactory: TabFlowViewFactory
    ) {
        self.onboardingViewFactory = onboardingViewFactory
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

    func makeOnboardingFlowView(
        onFlowEvent: @escaping (OnboardingFlowCoordinator.FlowEvent) -> Void
    ) -> OnboardingFlowView {
        OnboardingFlowView(
            viewFactory: onboardingViewFactory,
            onFlowEvent: onFlowEvent
        )
    }

    func makeAuthFlowView(
        onFlowEvent: @escaping (AuthFlowCoordinator.FlowEvent) -> Void
    ) -> AuthFlowView {
        AuthFlowView(
            viewFactory: authViewFactory,
            onFlowEvent: onFlowEvent
        )
    }

    func makeTabFlowView(
        onFlowEvent: @escaping (TabFlowCoordinator.FlowEvent) -> Void
    ) -> TabFlowView {
        TabFlowView(
            viewFactory: tabFlowViewFactory,
            onFlowEvent: onFlowEvent
        )
    }
}
