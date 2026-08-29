//
//  SplashStore.swift
//  Vexta
//
//  Created by MaxAdmin on 31.07.2026.
//

import Foundation
import Domain

@MainActor
@Observable
public final class SplashStore {

    // MARK: - State
    private(set) var state: SplashStoreState = .idle

    // MARK: - Dependency
    private let networkMonitor: NetworkMonitor
    private let fetchRemoteConfigUseCase: FetchRemoteConfigUseCase
    private let authStateObserver: AuthStateObserver

    // MARK: - Event
    private let onStoreEvent: (SplashStoreEvent) -> Void

    public init(
        networkMonitor: NetworkMonitor,
        fetchRemoteConfigUseCase: FetchRemoteConfigUseCase,
        authStateObserver: AuthStateObserver,
        onStoreEvent: @escaping (SplashStoreEvent) -> Void
    ) {
        self.networkMonitor = networkMonitor
        self.fetchRemoteConfigUseCase = fetchRemoteConfigUseCase
        self.authStateObserver = authStateObserver
        self.onStoreEvent = onStoreEvent
    }

    func bootstrap() async {
        guard !state.isLoading else { return }

        state = .loading(message: "Checking network connection...")
        try? await Task.sleep(for: .seconds(0.5))
        guard networkMonitor.isConnected else {
            handleError(.noInternetConnection)
            return
        }

        state = .loading(message: "Fetching configuration...")
        try? await Task.sleep(for: .seconds(0.5))
        if let message = await fetchRemoteConfigUseCase.fetchMaintenanceMessage() {
            handleError(.maintenanceMode(message: message))
            return
        }

        if let updateURL = await fetchRemoteConfigUseCase.fetchForceUpdateURL() {
            handleError(.forceUpdateRequired(storeURL: updateURL))
            return
        }

        state = .loading(message: "Authorization...")
        try? await Task.sleep(for: .seconds(0.5))
        let authState = authStateObserver.fetchAuthState()

        state = .completed

        switch authState {
        case .authenticated(let userId):
            onStoreEvent(.authenticated(userId: userId))
        case .unauthenticated:
            onStoreEvent(.unauthenticated)
        }
    }

    private func handleError(_ error: SplashError) {
        state = .failure(error: error)

        onStoreEvent(.alerted(
            error: error,
            onRetry: { [weak self] in await self?.bootstrap() }
            )
        )
    }
}
