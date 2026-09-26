//
//  RootCoordinator+ObserveHandler.swift
//  Vexta
//
//  Created by MaxAdmin on 26.09.2026.
//

import Foundation

// MARK: - Shared imports
import Domain
import Telemetry
import Notification

// MARK: - Feature imports
import FeatureSplash

extension RootCoordinator {

    func startSessionObservation() {
        #if DEBUG
        guard rootRoute != .debug else {
            return
        }
        #endif

        rootObserver.observeSession() { [weak self] observerEvent in
            self?.matchObserverEvent(for: observerEvent)
        }
    }

    private func matchObserverEvent(
        for observerEvent: RootObserver.ObserverEvent
    ) {
        switch observerEvent {

        case .networkStatus(let status):
            matchNetworkStatus(for: status)

        case .authState(let state):
            matchAuthState(for: state)

        case .notificationEvent(let event):
            matchNotificationEvent(for: event)

        case .remoteConfigValue(let remoteValue):
            matchRemoteConfigValue(for: remoteValue)

        case .subscriptionStatus(let status):
            matchSubscriptionStatus(for: status)
        }
    }
}

// MARK: - Observe event matching
extension RootCoordinator {

    private func matchNetworkStatus(for status: NetworkStatus) {
        switch status {

        case .connected:
            break

        case .requiresConnection:
            let networkAlert = alertFactory.makeAlert(for: NetworkError.requiresConnection)
            send(.presentedAlert(networkAlert))

        case .notConnected:
            let networkAlert = alertFactory.makeAlert(for: NetworkError.noInternet)
            send(.presentedAlert(networkAlert))
        }
    }

    private func matchAuthState(for state: AuthState) {
        switch state {

        case .authenticated:
            send(.presentedRoute(.mainTab))

        case .neededEmailVerification:
            send(.presentedRoute(.auth))

        case .unauthenticated:
            send(.presentedRoute(.auth))
        }
    }

    private func matchNotificationEvent(for event: NotificationEvent) {
        switch event {

        case .didReceive(let actionIdentifier, let userInfo):
            break
        case .willPresent(let userInfo):
            break
        }
    }

    private func matchRemoteConfigValue(for remoteValue: RemoteConfigValue) {
        switch remoteValue {

        case .boolValue(let key, let isForceUpdate) where key == RemoteConfigKey.isForceUpdate.toString:
            if isForceUpdate {
                let splashAlert = alertFactory.makeAlert(for: SplashError.forceUpdateRequired)
                send(.presentedAlert(splashAlert))
                execute(.lock(reason: "Force update required"))
            } else {
                execute(.unlock(with: .auth))
            }

        default:
            Log.ui.debug("Unhandled remote config key for value: \(remoteValue)")
        }
    }

    private func matchSubscriptionStatus(for status: SubscriptionStatus) {
        switch status {

        case .active:
            Log.purchase.debug("Active subscription status")

        case .inactive:
            Log.purchase.debug("Inactive subscription status")
        }
    }
}
