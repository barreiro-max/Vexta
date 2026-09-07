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

    // MARK: - Nested Types
    enum State {
        case idle
        case loading
        case failure(error: SplashError)

        var isLoading: Bool {
            if case .loading = self { true } else { false }
        }
    }

    public enum Event {
        case neededOnboarding
        case neededEmailVerification(userId: String)
        case authenticated(userId: String)
        case unauthenticated
        case alerted(error: SplashError, onRetry: @MainActor () async -> Void)
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - Dependency
    private let networkStatusObserver: NetworkStatusObserver
    private let fetchRemoteConfigUseCase: FetchRemoteConfigUseCase
    private let authStateObserver: AuthStateObserver
    private let checkOnboardingPassedUseCase: CheckOnboardingPassedUseCase

    // MARK: - Event
    private let onStoreEvent: (Event) -> Void

    // MARK: - Init
    public init(
        networkStatusObserver: NetworkStatusObserver,
        fetchRemoteConfigUseCase: FetchRemoteConfigUseCase,
        authStateObserver: AuthStateObserver,
        checkOnboardingPassedUseCase: CheckOnboardingPassedUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.networkStatusObserver = networkStatusObserver
        self.fetchRemoteConfigUseCase = fetchRemoteConfigUseCase
        self.authStateObserver = authStateObserver
        self.checkOnboardingPassedUseCase = checkOnboardingPassedUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Actions
    func bootstrap() async {
        guard !state.isLoading else { return }

        guard networkStatusObserver.isConnected else {
            handleError(.noInternetConnection)
            return
        }

        if let message = await fetchRemoteConfigUseCase.fetchMaintenanceMessage() {
            handleError(.maintenanceMode(message: message))
            return
        }

        if let updateURL = await fetchRemoteConfigUseCase.fetchForceUpdateURL() {
            handleError(.forceUpdateRequired(storeURL: updateURL))
            return
        }

        if !checkOnboardingPassedUseCase.execute() {
            onStoreEvent(.neededOnboarding)
            return
        }

        let authState = authStateObserver.fetchAuthState()
        switch authState {
        case .neededEmailVerification(let userId):
            onStoreEvent(.neededEmailVerification(userId: userId))
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
