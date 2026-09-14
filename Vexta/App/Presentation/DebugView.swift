//
//  DebugView.swift
//  Vexta
//
//  Created by MaxAdmin on 12.09.2026.
//
#if DEBUG
import SwiftUI

/// Change environment variable `DEBUG_VIEW` to `YES` if you want to see this view
///
/// - Important: Use ONLY for debug
struct DebugView: View {

    let onDebugRoute: (RootCoordinator.Route) -> Void
    let onDebugSheet: (RootCoordinator.Sheet?) -> Void

    var body: some View {
        NavigationStack {
            List {
                Section("Routes") {
                    Button("Launch Onboarding Flow") { onDebugRoute(.onboarding) }
                    Button("Launch Auth Flow") { onDebugRoute(.auth) }
                    Button("Launch Tab Flow") { onDebugRoute(.mainTab) }
                }

                Section("Sheets") {
                    Button("Launch EmailVerification Sheet") { onDebugSheet(.emailVerification) }
                    Button("Launch Subscription Sheet") { onDebugSheet(.subscription) }
                    Button("Launch CustomCenter Sheet") { onDebugSheet(.purchaseSupport) }
                }
            }
            .navigationTitle("DEBUG VIEW")
        }
    }
}
#endif
