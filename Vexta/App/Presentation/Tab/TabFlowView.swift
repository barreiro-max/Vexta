//
//  TabFlowView.swift
//  Vexta
//
//  Created by MaxAdmin on 25.08.2026.
//

import SwiftUI

struct TabFlowView: View {

    @State private var coordinator: TabFlowCoordinator

    init(
        viewFactory: TabFlowViewFactory,
        onFlowEvent: @escaping (TabFlowCoordinator.FlowEvent) -> Void,
    ) {
        let coordinator = TabFlowCoordinator(
            tabFlowViewFactory: viewFactory,
            onFlowEvent: onFlowEvent
        )
        _coordinator = State(wrappedValue: coordinator)
    }

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {

            Tab("Main", systemImage: "house", value: .main) {
                coordinator.featureFlowView(for: .main)
            }

            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                coordinator.featureFlowView(for: .search)
            }

            Tab("Cart", systemImage: "cart", value: .cart) {
                coordinator.featureFlowView(for: .cart)
            }

            Tab("Profile", systemImage: "person.fill", value: .profile) {
                coordinator.featureFlowView(for: .profile)
            }
        }
    }
}
