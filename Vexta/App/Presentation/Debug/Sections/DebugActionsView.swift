//
//  DebugActionsView.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//

#if DEBUG
import SwiftUI
import Presentation
import Domain
import Environment

struct DebugActionsView: View {

    let onDebugRoute: (RootCoordinator.Route) -> Void
    let onDebugSheet: (RootCoordinator.Sheet?) -> Void
    let onDebugAlert: (AppAlert?) -> Void

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

                    Button("Launch Subscription Sheet") {
                        if !EnvironmentVariables.isUserPremium {
                            onDebugSheet(.subscription)
                        }
                    }

                    Button("Launch CustomCenter Sheet") { onDebugSheet(.purchaseSupport) }
                }

                Section("Alerts") {
                    Button("Launch NetworkError.noInternet Alert", role: .destructive) {
                        onDebugAlert(AppAlert(error: NetworkError.noInternet))
                    }
                }
            }
            .navigationTitle("Actions")
        }
    }
}
#endif
