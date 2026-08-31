//
//  SplashStore.swift
//  Vexta
//
//  Created by MaxAdmin on 31.07.2026.
//

import SwiftUI
import Domain

public struct SplashView: View {

    @State private var store: SplashStore

    public init(store: SplashStore) {
        _store = State(wrappedValue: store)
    }

    public var body: some View {
        VStack{}
            .task(store.bootstrap)
            .refreshable(action: store.bootstrap)
    }
}

#Preview {
    let isConnected = true
    let isPreviewMaintenance = false
    let isPreviewForceUpdate = false
    let isAuthenticated = true
    let isPassedOnboarding = true

    let networkMonitor = PreviewNetworkMonitor(
        isConnected: isConnected
    )
    let fetchRemoteConfigUseCase = PreviewFetchRemoteConfigUseCase(
        isPreviewMaintenance: isPreviewMaintenance,
        isPreviewForceUpdate: isPreviewForceUpdate
    )
    let authStateObserver = PreviewAuthStateObserver(
        isAuthenticated: isAuthenticated
    )
    let checkOnboardingPassedUseCase = PreviewCheckOnboardingPassedUseCase(
        isPassed: isPassedOnboarding
    )

    let store = SplashStore(
        networkMonitor: networkMonitor,
        fetchRemoteConfigUseCase: fetchRemoteConfigUseCase,
        authStateObserver: authStateObserver,
        checkOnboardingPassedUseCase: checkOnboardingPassedUseCase,
        onStoreEvent: {_ in}
    )
    SplashView(store: store)
}
