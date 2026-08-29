//
//  TabFlowCoordinator.swift
//  Vexta
//
//  Created by MaxAdmin on 25.08.2026.
//

import SwiftUI

// MARK: - shared
import Telemetry

// MARK: - feature
import FeatureMain

@MainActor
@Observable
final class TabFlowCoordinator {
    var selectedTab: MainFlowTab = .main

    private let tabFlowViewFactory: TabFlowViewFactory

    private let onFlowEvent: (TabFlowCoordinatorEvent) -> Void

    init(
        tabFlowViewFactory: TabFlowViewFactory,
        onFlowEvent: @escaping (TabFlowCoordinatorEvent) -> Void
    ) {
        self.tabFlowViewFactory = tabFlowViewFactory
        self.onFlowEvent = onFlowEvent
    }

    // MARK: - flow views
    var mainFlowView: MainFlowView {
        tabFlowViewFactory.makeMainFlowView { [weak self] flowEvent in
            self?.matchMainFlowEvent(for: flowEvent)
        }
    }
}

extension TabFlowCoordinator {
    func send(_ intent: TabFlowCoordinatorIntent) {
        switch intent {

        case .finishedMain:
            onFlowEvent(.finishedMain)

        case .showMainAlert(let error):
            onFlowEvent(.alertedMain(with: error))
        }

        Log.ui.debug("Send intent: \(intent)")
    }
}

extension TabFlowCoordinator {
    private func matchMainFlowEvent(for flowEvent: MainFlowCoordinator.FlowEvent) {
        switch flowEvent {
        case .finished:
            send(.finishedMain)
        case .alerted(let error):
            send(.showMainAlert(with: error))
        }
    }
}
