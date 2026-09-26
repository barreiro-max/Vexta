//
//  RootCoordinator+SessionEventMatcher.swift
//  Vexta
//
//  Created by MaxAdmin on 26.09.2026.
//

import Foundation

// MARK: - Shared imports
import Telemetry

extension RootCoordinator {

    func matchUserPremiumStatusSessionEvent(for sessionEvent: RootSession.SessionEvent) {
        switch sessionEvent {

        case .userHasPremium:
            Log.purchase.debug("User already has premium")

        case .userHasNotPremium:
            send(.presentedSheet(.subscription))
        }
    }
}
