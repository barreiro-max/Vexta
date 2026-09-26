//
//  RootCoordinator+FlowEventMatching.swift
//  Vexta
//
//  Created by MaxAdmin on 26.09.2026.
//

import Foundation

// MARK: - Shared imports
import Domain
import Presentation

// MARK: - Feature imports
import FeatureSplash
import FeatureOnboarding
import FeatureAuth

extension RootCoordinator {

    func matchOnboardingFlowEvent(for flowEvent: OnboardingFlowCoordinator.FlowEvent) {
        switch flowEvent {
        case .completed, .skipped:
            send(.presentedRoute(.auth))
        }
    }

    func matchSplashEvent(for storeEvent: SplashStore.Event) {
        switch storeEvent {

        case .locked:
            execute(.lock(reason: "Force update required"))

        case .neededOnboarding:
            send(.presentedRoute(.onboarding))

        case .neededEmailVerification:
            send(.presentedRoute(.auth))

        case .authenticated:
            send(.presentedRoute(.mainTab))

        case .unauthenticated:
            send(.presentedRoute(.auth))

        case .alerted(let splashError, let onRetry):
            let splashAlert = alertFactory.makeRetryAlert(for: splashError, onRetry: onRetry)
            send(.presentedAlert(splashAlert))
        }
    }

    func matchAuthFlowEvent(for flowEvent: AuthFlowCoordinator.FlowEvent) {
        switch flowEvent {

        case .finished:
            send(.presentedRoute(.mainTab))
            send(.presentedPaywallIfNeeded)

        case .alerted(let authError):
            guard authError != .emailNotVerified else {
                send(.presentedSheet(.emailVerification))
                return
            }

            let authAlert = alertFactory.makeAlert(for: authError)
            send(.presentedAlert(authAlert))
        }
    }

    func matchTabFlowEvent(for flowEvent: TabFlowCoordinator.FlowEvent) {
        switch flowEvent {

        case .finishedMain:
            send(.presentedRoute(.auth))

        case .alertedMain(let error):
            let alert = alertFactory.makeAlert(for: error)
            send(.presentedAlert(alert))

        case .showPaywallIfNeeded:
            send(.presentedPaywallIfNeeded)
        }
    }
}
