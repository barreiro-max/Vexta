//
//  RootFlowView.swift
//  Vexta
//
//  Created by MaxAdmin on 14.06.2026.
//

import SwiftUI
import Presentation

struct RootFlowView: View {

    @State private var coordinator: RootCoordinator

    init(coordinator: RootCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
    }

    var body: some View {
        coordinator.rootView
            .animation(.default, value: coordinator.rootRoute)
            .sheet(item: $coordinator.rootSheet) { rootSheet in
                coordinator.featureFlowView(by: rootSheet)
            }
            .handleAppAlert($coordinator.alert)
    }
}

#Preview {
    let container = RootContainer()
    let coordinator = container.makeRootCoordinator()
    RootFlowView(coordinator: coordinator)
}
