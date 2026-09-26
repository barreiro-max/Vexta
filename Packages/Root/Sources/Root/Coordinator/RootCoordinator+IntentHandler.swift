//
//  RootCoordinator+IntentHandler.swift
//  Vexta
//
//  Created by MaxAdmin on 26.09.2026.
//

import Foundation

// MARK: - Shared imports
import Presentation
import Telemetry

extension RootCoordinator {

    enum Intent {
        case presentedRoute(_ route: Route)
        case presentedSheet(_ sheet: Sheet)
        case dismissedSheet
        case presentedAlert(_ alert: AppAlert)
        case dismissedAlert

        case presentedPaywallIfNeeded
    }

    func send(_ intent: RootCoordinator.Intent) {
        if rootRoute.isLock {
            Log.ui.debug("App in lock, intent dropped: \(intent)")
            return
        }

        switch intent {
        case .presentedRoute(let rootRoute):
            if self.rootRoute != rootRoute {
                self.rootRoute = rootRoute
            }

        case .presentedSheet(let rootSheet):
            if self.rootSheet != rootSheet {
                self.rootSheet = rootSheet
            }

        case .dismissedSheet:
            if self.rootSheet != nil {
                self.rootSheet = nil
            }

        case .presentedAlert(let alert):
            self.alert = alert

        case .dismissedAlert:
            self.alert = nil

        case .presentedPaywallIfNeeded:
            rootSession.validateUserPremiumStatus { [weak self] sessionEvent in
                self?.matchUserPremiumStatusSessionEvent(for: sessionEvent)
            }
        }

        Log.ui.debug("Send intent: \(intent)")
    }
}
