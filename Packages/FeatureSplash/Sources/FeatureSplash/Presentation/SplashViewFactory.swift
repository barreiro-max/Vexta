//
//  SplashViewFactory.swift
//  Vexta
//
//  Created by MaxAdmin on 08.08.2026.
//

import Foundation
import Domain

@MainActor
public struct SplashViewFactory {

    private let networkMonitor: NetworkMonitor
    private let fetchRemoteConfigUseCase: FetchRemoteConfigUseCase
    private let authStateObserver: AuthStateObserver
    private let checkOnboardingPassedUseCase: CheckOnboardingPassedUseCase

    public init(
        networkMonitor: NetworkMonitor,
        fetchRemoteConfigUseCase: FetchRemoteConfigUseCase,
        authStateObserver: AuthStateObserver,
        checkOnboardingPassedUseCase: CheckOnboardingPassedUseCase
    ) {
        self.networkMonitor = networkMonitor
        self.fetchRemoteConfigUseCase = fetchRemoteConfigUseCase
        self.authStateObserver = authStateObserver
        self.checkOnboardingPassedUseCase = checkOnboardingPassedUseCase
    }

    public func makeSplashView(
        onStoreEvent: @escaping (SplashStore.Event) -> Void
    ) -> SplashView {
        let store = SplashStore(
            networkMonitor: networkMonitor,
            fetchRemoteConfigUseCase: fetchRemoteConfigUseCase,
            authStateObserver: authStateObserver,
            checkOnboardingPassedUseCase: checkOnboardingPassedUseCase,
            onStoreEvent: onStoreEvent
        )
        return SplashView(store: store)
    }
}
