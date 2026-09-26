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
public final class RootCoordinator {

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
    private var debugViewId = UUID()
#endif
    
    // MARK: - ViewFactory
    private let rootViewFactory: any RootViewFactory
    private let rootSheetFactory: any RootSheetFactory

    // MARK: - Alert
    let alertFactory: any RootAlertFactory

    // MARK: - Observer
    let rootObserver: RootObserver

    // MARK: - Session
    let rootSession: RootSession

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
