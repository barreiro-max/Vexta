//
//  MainFlowView.swift
//  Vexta
//
//  Created by MaxAdmin on 29.07.2026.
//

import SwiftUI

public struct MainFlowView: View {

    @State private var coordinator: MainFlowCoordinator

    public init(
        viewFactory: MainViewFactory,
        onFlowEvent: @escaping (MainFlowCoordinator.FlowEvent) -> Void
    ) {
        let coordinator = MainFlowCoordinator(
            viewFactory: viewFactory,
            onFlowEvent: onFlowEvent
        )

        self._coordinator = State(wrappedValue: coordinator)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView
                .navigationDestination(for: MainFlowCoordinator.Route.self) { route in
                    coordinator.chlidView(by: route)
                }
        }
        .animation(.default, value: coordinator.path)
    }
}

#Preview {
    let logOutUseCase = PreviewLogOutUseCase()
    let viewFactory = MainViewFactory(logOutUseCase: logOutUseCase)
    MainFlowView(viewFactory: viewFactory) { _ in }
}
