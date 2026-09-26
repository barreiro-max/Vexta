//
//  DebugView.swift
//  Vexta
//
//  Created by MaxAdmin on 12.09.2026.
//
#if DEBUG
import SwiftUI
import Presentation
import Environment
import Telemetry

/// Change environment variable `DEBUG_VIEW` to `YES` if you want to see this view
///
/// - Important: Use ONLY for debug
struct DebugView: View {

    @State private var selectedTab: DebugTab = .actions

    let onDebugRoute: (RootCoordinator.Route) -> Void
    let onDebugSheet: (RootCoordinator.Sheet?) -> Void
    let onDebugAlert: (AppAlert?) -> Void
    let onForceRefresh: () -> Void

    public var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(DebugTab.allCases) { tab in
                Tab(tab.rawValue, systemImage: tab.systemImage, value: tab) {
                    refreshViewButton
                    tabContent(for: tab)
                        .onAppear {
                            Log.ui.debug("DebugTab appeared: \(tab)")
                        }
                }
            }
        }
    }

    private var refreshViewButton: some View {
        Button("Refresh debug view", action: onForceRefresh)
    }

    @ViewBuilder
    private func tabContent(for tab: DebugTab) -> some View {
        switch tab {

        case .actions:
            DebugActionsView(
                onDebugRoute: onDebugRoute,
                onDebugSheet: onDebugSheet,
                onDebugAlert: onDebugAlert
            )

        case .system:
            DebugSystemInfoView(
                environment: BuildConfiguration.environment.configTitle
            )

        case .environment:
            DebugEnvironmentView()
        }
    }
}
#endif
