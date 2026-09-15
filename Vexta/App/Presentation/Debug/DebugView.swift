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

/// Change environment variable `DEBUG_VIEW` to `YES` if you want to see this view
///
/// - Important: Use ONLY for debug
struct DebugView: View {

    @State private var selectedTab: DebugTab = .actions

    let onDebugRoute: (RootCoordinator.Route) -> Void
    let onDebugSheet: (RootCoordinator.Sheet?) -> Void
    let onDebugAlert: (AppAlert?) -> Void

    public var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(DebugTab.allCases) { tab in
                Tab(tab.rawValue, systemImage: tab.systemImage, value: tab) {
                    tabContent(for: tab)
                }
            }
        }
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
                environment: InfoPlistConfiguration.currentAppEnvironment
            )

        case .environment:
            DebugEnvironmentView()
        }
    }
}
#endif
