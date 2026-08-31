//
//  TabFlowCoordinator.swift
//  Vexta
//
//  Created by MaxAdmin on 25.08.2026.
//

import SwiftUI

// MARK: - Shared imports
import Domain
import Telemetry

// MARK: - Feature imports
import FeatureMain

@MainActor
@Observable
final class TabFlowCoordinator {

    // MARK: - Nested Types
    enum FlowEvent {
        case finishedMain
        case alertedMain(with: AccountError)
    }

    enum Tab: Int, Equatable, Hashable {
        case main
        case search
        case cart
        case profile
    }

    // MARK: - Tab
    var selectedTab: Tab = .main

    // MARK: - Dependencies
    private let tabFlowViewFactory: TabFlowViewFactory

    // MARK: - FlowEvent
    private let onFlowEvent: (FlowEvent) -> Void

    // MARK: - Init
    init(
        tabFlowViewFactory: TabFlowViewFactory,
        onFlowEvent: @escaping (FlowEvent) -> Void
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

// MARK: - Intent Handler
extension TabFlowCoordinator {

    enum Intent {
        case finishedMain
        case showMainAlert(with: AccountError)
    }

    func send(_ intent: Intent) {
        switch intent {

        case .finishedMain:
            onFlowEvent(.finishedMain)

        case .showMainAlert(let error):
            onFlowEvent(.alertedMain(with: error))
        }

        Log.ui.debug("Send intent: \(intent)")
    }
}

// MARK: - Flow Event Matching
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
