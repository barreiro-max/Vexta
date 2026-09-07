//
//  RootObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 05.09.2026.
//

import Foundation

// MARK: - shared imports
import Domain
import Telemetry
import Notification

@MainActor
final class RootObserver {

    // MARK: - Nested Types
    enum ObserverEvent {
        case networkStatus(with: NetworkStatus)
        case authState(with: AuthState)
        case notificationEvent(with: NotificationEvent)
    }

    // MARK: - Observers
    private let networkStatusObserver: NetworkStatusObserver
    private let authStateObserver: AuthStateObserver
    private let notificationEventObserver: NotificationEventObserver

    // MARK: - Concurrency Tasks
    private var networkStatusObserverTask: Task<Void, Never>?
    private var authStateObserverTask: Task<Void, Never>?
    private var notificationEventObserverTask: Task<Void, Never>?

    // MARK: - Init
    init(
        networkStatusObserver: NetworkStatusObserver,
        authStateObserver: AuthStateObserver,
        notificationEventObserver: NotificationEventObserver,
    ) {
        self.networkStatusObserver = networkStatusObserver
        self.authStateObserver = authStateObserver
        self.notificationEventObserver = notificationEventObserver
    }

    func observeSession(
        onObserverEvent: @escaping @MainActor (RootObserver.ObserverEvent) -> Void
    ) {
        observeNetworkStatus(onObserverEvent: onObserverEvent)
        observeAuthState(onObserverEvent: onObserverEvent)
        observeNotificationEvent(onObserverEvent: onObserverEvent)
#warning("implement `observeRemoteConfigValue` (for example: real time update navigation for close application on maintenance)")
// TODO: — implement `observePurchaseTransaction()` for observing, is user makes purchase
    }

    private func observeNetworkStatus(
        onObserverEvent: @escaping @MainActor (RootObserver.ObserverEvent) -> Void
    ) {
        networkStatusObserverTask?.cancel()

        networkStatusObserverTask = Task {
            for await status in networkStatusObserver.stream {
                if Task.isCancelled { break }
                onObserverEvent(.networkStatus(with: status))
            }
        }
    }

    private func observeAuthState(
        onObserverEvent: @escaping @MainActor (RootObserver.ObserverEvent) -> Void
    ) {
        authStateObserverTask?.cancel()

        authStateObserverTask = Task {
            for await state in authStateObserver.stream {
                if Task.isCancelled { break }
                onObserverEvent(.authState(with: state))
            }
        }
    }

    private func observeNotificationEvent(
        onObserverEvent: @escaping @MainActor (RootObserver.ObserverEvent) -> Void
    ) {
        notificationEventObserverTask?.cancel()

        notificationEventObserverTask = Task {
            for await event in notificationEventObserver.stream {
                if Task.isCancelled { break }
                onObserverEvent(.notificationEvent(with: event))
            }
        }
    }

    deinit {
        networkStatusObserverTask?.cancel()
        authStateObserverTask?.cancel()
        notificationEventObserverTask?.cancel()
    }
}
