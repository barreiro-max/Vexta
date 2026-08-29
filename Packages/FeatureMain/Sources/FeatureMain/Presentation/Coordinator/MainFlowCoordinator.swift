//
//  MainFlowCoordinator.swift
//  Vexta
//
//  Created by MaxAdmin on 29.07.2026.
//

import SwiftUI
import Telemetry

@MainActor
@Observable
final class MainFlowCoordinator {
    var path: [MainRoute] = []

    private let viewFactory: MainViewFactory

    private let onFlowEvent: (MainFlowCoordinatorEvent) -> Void

    init(
        viewFactory: MainViewFactory,
        onFlowEvent: @escaping (MainFlowCoordinatorEvent) -> Void
    ) {
        self.viewFactory = viewFactory
        self.onFlowEvent = onFlowEvent
    }

    var rootView: some View {
        chlidView(by: .main)
    }

    @ViewBuilder
    func chlidView(by route: MainRoute) -> some View {
        switch route {
        case .main:
            viewFactory.makeMainView { [weak self] storeEvent in
                self?.matchMainEvent(for: storeEvent)
            }
        }
    }
}

extension MainFlowCoordinator {
    func send(_ intent: MainFlowCoordinatorIntent) {
        switch intent {

        case .finishedFlow:
            onFlowEvent(.finished)

        case .showAlert(let error):
            onFlowEvent(.alerted(error: error))
        }

        Log.ui.debug("Send intent: \(intent)")
    }
}


extension MainFlowCoordinator {
    private func matchMainEvent(for storeEvent: MainStoreEvent) {
        switch storeEvent {
            
        case .logOutTapped:
            send(.finishedFlow)
        }
    }
}
