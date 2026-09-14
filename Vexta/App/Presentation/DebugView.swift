//
//  DebugView.swift
//  Vexta
//
//  Created by MaxAdmin on 12.09.2026.
//
#if DEBUG
import SwiftUI
import Domain
import Presentation

/// Change environment variable `DEBUG_VIEW` to `YES` if you want to see this view
///
/// - Important: Use ONLY for debug
struct DebugView: View {

    let onDebugRoute: (RootCoordinator.Route) -> Void
    let onDebugSheet: (RootCoordinator.Sheet?) -> Void
    let onDebugAlert: (AppAlert?) -> Void

    var body: some View {
        NavigationStack {
            List {
                sectionRoutes
                sectionSheets
                sectionAlerts
            }
            .navigationTitle("DEBUG VIEW")
        }
    }

    private var sectionRoutes: some View {
        Section("Routes") {
            Button("Launch Onboarding Flow") { onDebugRoute(.onboarding) }
            Button("Launch Auth Flow") { onDebugRoute(.auth) }
            Button("Launch Tab Flow") { onDebugRoute(.mainTab) }
        }
    }

    private var sectionSheets: some View {
        Section("Sheets") {
            Button("Launch EmailVerification Sheet") { onDebugSheet(.emailVerification) }
            Button("Launch Subscription Sheet") { onDebugSheet(.subscription) }
            Button("Launch CustomCenter Sheet") { onDebugSheet(.purchaseSupport) }
        }
    }

    private var sectionAlerts: some View {
        Section("Alerts") {
            Button("Launch NetworkError.noInternet Alert", role: .destructive) {
                let alert = AppAlert(error: NetworkError.noInternet)
                onDebugAlert(alert)
            }
        }
    }
}
#endif
