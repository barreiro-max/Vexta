//
//  TabFlowView.swift
//  Vexta
//
//  Created by MaxAdmin on 25.08.2026.
//

import SwiftUI

import FeatureMain
import Notification
import FeaturePurchase

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
                coordinator.mainFlowView
            }
            // make other featureFlowViews by main example
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                Text("Search")
            }

            Tab("Cart", systemImage: "cart", value: .cart) {
                Text("Cart")
            }

            Tab("Profile", systemImage: "person.fill", value: .profile) {
                Text("Profile")
            }
        }
    }
}
