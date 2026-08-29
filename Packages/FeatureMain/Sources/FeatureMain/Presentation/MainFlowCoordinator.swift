//
//  MainFlowCoordinator.swift
//  Vexta
//
//  Created by MaxAdmin on 29.07.2026.
//

import SwiftUI
import Telemetry
import Domain

@MainActor
@Observable
public final class MainFlowCoordinator {

    // MARK: - Nested Types
    public enum FlowEvent {
        case finished
        case alerted(error: MainError)
    }

    enum Route: Hashable, Codable {
        case main
    }

    // MARK: - Path
    var path: [Route] = []

    // MARK: - Dependencies
    private let viewFactory: MainViewFactory

    // MARK: - FlowEvent
    private let onFlowEvent: (FlowEvent) -> Void

    // MARK: - Init
    init(
        viewFactory: MainViewFactory,
        onFlowEvent: @escaping (FlowEvent) -> Void
    ) {
        self.viewFactory = viewFactory
        self.onFlowEvent = onFlowEvent
    }

    // MARK: - View Destination
    var rootView: some View {
        chlidView(by: .main)
    }

    @ViewBuilder
    func chlidView(by route: Route) -> some View {
        switch route {
        case .main:
            viewFactory.makeMainView { [weak self] storeEvent in
                self?.matchMainEvent(for: storeEvent)
            }
        }
    }
}

// MARK: - Intent Handler
extension MainFlowCoordinator {

    enum Intent {
        case finishedFlow
        case showAlert(error: MainError)
    }

    func send(_ intent: Intent) {
        switch intent {

        case .finishedFlow:
            onFlowEvent(.finished)

        case .showAlert(let error):
            onFlowEvent(.alerted(error: error))
        }

        Log.ui.debug("Send intent: \(intent)")
    }
}

// MARK: - Store Event Matching
extension MainFlowCoordinator {

    private func matchMainEvent(for storeEvent: MainStore.Event) {
        switch storeEvent {
            
        case .logOutTapped:
            send(.finishedFlow)
        }
    }
}
