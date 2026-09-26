//
//  RootObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 05.09.2026.
//

import Foundation

// MARK: - Shared imports
import Domain
import Telemetry
import Notification

@MainActor
final class RootObserver {

    typealias OnObserverEvent = @MainActor (RootObserver.ObserverEvent) -> Void

    // MARK: - Nested Types
    enum ObserverEvent {
        case networkStatus(with: NetworkStatus)
        case authState(with: AuthState)
        case notificationEvent(with: NotificationEvent)
        case remoteConfigValue(with: RemoteConfigValue)
        case subscriptionStatus(with: SubscriptionStatus)
    }

    // MARK: - Observers
    private let networkStatusObserver: NetworkStatusObserver
    private let authStateObserver: AuthStateObserver
    private let notificationEventObserver: NotificationEventObserver
    private let remoteConfigValueObserver: RemoteConfigValueObserver
    private let subscriptionStatusObserver: SubscriptionStatusObserver

    private var onObserverEvent: OnObserverEvent?

    // MARK: - Concurrency Tasks
    private var networkStatusObserverTask: Task<Void, Never>?
    private var authStateObserverTask: Task<Void, Never>?
    private var notificationEventObserverTask: Task<Void, Never>?
    private var remoteConfigValueObserverTask: Task<Void, Never>?
    private var subscriptionStatusObserverTask: Task<Void, Never>?

    // MARK: - Init
    init(
        networkStatusObserver: NetworkStatusObserver,
        authStateObserver: AuthStateObserver,
        notificationEventObserver: NotificationEventObserver,
        remoteConfigValueObserver: RemoteConfigValueObserver,
        subscriptionStatusObserver: SubscriptionStatusObserver,
    ) {
        self.networkStatusObserver = networkStatusObserver
        self.authStateObserver = authStateObserver
        self.notificationEventObserver = notificationEventObserver
        self.remoteConfigValueObserver = remoteConfigValueObserver
        self.subscriptionStatusObserver = subscriptionStatusObserver
    }

    func observeSession(
        onObserverEvent: @escaping OnObserverEvent
    ) {
        self.onObserverEvent = onObserverEvent
        
        observeNetworkStatus()
        observeAuthState()
        observeNotificationEvent()
        observeRemoteConfigValue()
        observeSubscriptionStatus()
    }

    private func observeNetworkStatus() {
        networkStatusObserverTask?.cancel()

        networkStatusObserverTask = Task {
            for await status in networkStatusObserver.stream {
                if Task.isCancelled { break }
                onObserverEvent?(.networkStatus(with: status))
            }
        }
    }

    private func observeAuthState() {
        authStateObserverTask?.cancel()

        authStateObserverTask = Task {
            for await state in authStateObserver.stream {
                if Task.isCancelled { break }
                onObserverEvent?(.authState(with: state))
            }
        }
    }

    private func observeNotificationEvent() {
        notificationEventObserverTask?.cancel()

        notificationEventObserverTask = Task {
            for await event in notificationEventObserver.stream {
                if Task.isCancelled { break }
                onObserverEvent?(.notificationEvent(with: event))
            }
        }
    }

    private func observeRemoteConfigValue() {
        remoteConfigValueObserverTask?.cancel()

        remoteConfigValueObserverTask = Task {
            for await value in remoteConfigValueObserver.stream {
                if Task.isCancelled { break }
                onObserverEvent?(.remoteConfigValue(with: value))
            }
        }
    }

    private func observeSubscriptionStatus() {
        subscriptionStatusObserverTask?.cancel()

        subscriptionStatusObserverTask = Task {
            for await status in subscriptionStatusObserver.stream {
                if Task.isCancelled { break }
                onObserverEvent?(.subscriptionStatus(with: status))
            }
        }
    }

    deinit {
        networkStatusObserverTask?.cancel()
        authStateObserverTask?.cancel()
        notificationEventObserverTask?.cancel()
        remoteConfigValueObserverTask?.cancel()
        subscriptionStatusObserverTask?.cancel()
    }
}
