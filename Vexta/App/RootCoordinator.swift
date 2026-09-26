//
//  RootCoordinator.swift
//  Vexta
//
//  Created by MaxAdmin on 21.07.2026.
//

import SwiftUI

// MARK: - Shared imports
import Domain
import Data
import Presentation
import Telemetry
import Notification
import Environment

// MARK: - Feature imports
import FeatureSplash
import FeatureOnboarding
import FeatureAuth
import FeaturePurchase

@MainActor
@Observable
final class RootCoordinator {

    // MARK: - Nested Types
    enum Route: Hashable, Codable, Identifiable, Sendable {
        case lock(reason: String)
        case splash
        case onboarding
        case auth
        case mainTab

    #if DEBUG
        case debug
    #endif

        var isLock: Bool {
            if case .lock = self { true } else { false }
        }

        var id: String { "\(self)" }
    }

    enum Sheet: Hashable, Identifiable, Sendable {
        case subscription
        case purchaseSupport
        case emailVerification

        var id: String { "\(self)" }
    }

    // MARK: - Navigation & Alert
    var rootRoute: Route
    var rootSheet: Sheet?
    var alert: AppAlert?

#if DEBUG
    var debugViewId = UUID()
#endif

    // MARK: - Factory
    private let rootViewFactory: any RootViewFactory
    private let alertFactory: any RootAlertFactory
    private let rootSheetFactory: any RootSheetFactory

    // MARK: - Observer
    private let rootObserver: RootObserver

    // MARK: - Session
    private let rootSession: RootSession

    // MARK: - Init
    init(
        rootViewFactory:            any RootViewFactory,
        alertFactory:               any RootAlertFactory,
        rootSheetFactory:           any RootSheetFactory,
        rootObserver:               RootObserver,
        rootSession:                RootSession,
    ) {
        self.rootViewFactory = rootViewFactory
        self.alertFactory = alertFactory
        self.rootSheetFactory = rootSheetFactory
        self.rootObserver = rootObserver
        self.rootSession = rootSession

        // MARK: - Define Root Route
    #if DEBUG
        rootRoute = BuildConfiguration.isUseDebugView ? .debug : .splash
    #else
        rootRoute = .splash
    #endif

        // MARK: - Start Observion
        startSessionObservation()
    }

    // MARK: - View Destination
    var rootView: some View {
        featureFlowView(by: rootRoute)
    }

    @ViewBuilder
    private func featureFlowView(by route: Route) -> some View {
        Group {
            switch route {

            case .lock(let reason):
                LockView(reason: reason) // TODO: Lock screen

            case .splash:
                rootViewFactory.makeSplashView { [weak self] storeEvent in
                    self?.matchSplashEvent(for: storeEvent)
                }

            case .onboarding:
                rootViewFactory.makeOnboardingFlowView { [weak self] flowEvent in
                    self?.matchOnboardingFlowEvent(for: flowEvent)
                }

            case .auth:
                rootViewFactory.makeAuthFlowView { [weak self] flowEvent in
                    self?.matchAuthFlowEvent(for: flowEvent)
                }

            case .mainTab:
                rootViewFactory.makeTabFlowView { [weak self] flowEvent in
                    self?.matchTabFlowEvent(for: flowEvent)
                }

#if DEBUG
            case .debug:
                debugView.id(debugViewId)
#endif
            }
        }
        .onAppear { Log.ui.debug("Route appeared: \(route)") }
    }

    #if DEBUG
    private var debugView: some View {
        DebugView { [weak self] debugRoute in
            self?.rootRoute = debugRoute
        } onDebugSheet: { [weak self] debugSheet in
            self?.rootSheet = debugSheet
        } onDebugAlert: { [weak self] debugAlert in
            self?.alert = debugAlert
        } onForceRefresh: {
            self.debugViewId = UUID()
        }
    }
    #endif

    @ViewBuilder
    func featureFlowView(by sheet: Sheet) -> some View {
        Group {
            switch sheet {

            case .subscription:
                rootSheetFactory.makeSubscriptionSheet { [weak self] sheetEvent in
                    self?.matchSubscriptionSheetEvent(for: sheetEvent)
                }

            case .purchaseSupport:
                rootSheetFactory.makeCustomerCenterSheet()

            case .emailVerification:
                rootSheetFactory.makeEmailVerificationSheet()
            }
        }
        .onAppear { Log.ui.debug("Sheet appeared: \(sheet)") }
    }
}

// MARK: - Intent Handler
extension RootCoordinator {

    enum Intent {
        case presentedRoute(_ route: Route)
        case presentedSheet(_ sheet: Sheet)
        case dismissedSheet
        case presentedAlert(_ alert: AppAlert)
        case dismissedAlert

        case presentedPaywallIfNeeded
    }

    private func send(_ intent: RootCoordinator.Intent) {
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

// MARK: - Command Handler
extension RootCoordinator {

    enum Command {
        case lock(reason: String)
        case unlock(with: Route)
    }

    private func execute(_ command: RootCoordinator.Command) {
        self.rootSheet = nil

        switch command {
        case .unlock(let route):
            if rootRoute.isLock {
                self.rootRoute = route
            }

        case .lock(let reason):
            self.rootRoute = .lock(reason: reason)
        }

        Log.ui.warning("Send command: \(command)")
    }
}

// MARK: - Flow Event Matching
extension RootCoordinator {

    private func matchOnboardingFlowEvent(for flowEvent: OnboardingFlowCoordinator.FlowEvent) {
        switch flowEvent {
        case .completed, .skipped:
            send(.presentedRoute(.auth))
        }
    }

    private func matchSplashEvent(for storeEvent: SplashStore.Event) {
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

    private func matchAuthFlowEvent(for flowEvent: AuthFlowCoordinator.FlowEvent) {
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

    private func matchTabFlowEvent(for flowEvent: TabFlowCoordinator.FlowEvent) {
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

// MARK: - Observe handle
extension RootCoordinator {

    private func startSessionObservation() {
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

// MARK: - Sheet Event Matching
extension RootCoordinator {

    private func matchSubscriptionSheetEvent(for sheetEvent: SubscriptionSheetStore.SheetEvent) {
        switch sheetEvent {

        case .checkUserPremiumSucceeded: break

        case .checkUserPremiumFailed(let error):
            let purchaseAlert = alertFactory.makeAlert(for: error)
            send(.presentedAlert(purchaseAlert))
        }
    }
}

// MARK: - Session Event Matching
extension RootCoordinator {

    private func matchUserPremiumStatusSessionEvent(for sessionEvent: RootSession.SessionEvent) {
        switch sessionEvent {

        case .userHasPremium:
            Log.purchase.debug("User already has premium")

        case .userHasNotPremium:
            send(.presentedSheet(.subscription))
        }
    }
}
