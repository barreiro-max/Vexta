//
//  OnboardingFlowCoordinator.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import SwiftUI
import Telemetry

@MainActor
@Observable
public final class OnboardingFlowCoordinator {

    // MARK: - Nested Types
    public enum FlowEvent {
        case completed
        case skipped
    }

    enum Route {
        case start
        case finish
    }

    // MARK: - Path
    var path: [Route] = []

    // MARK: - Dependencies
    private let viewFactory: OnboardingViewFactory

    // MARK: - FlowEvent
    private let onFlowEvent: (FlowEvent) -> Void

    // MARK: - Init
    init(
        viewFactory: OnboardingViewFactory,
        onFlowEvent: @escaping (FlowEvent) -> Void
    ) {
        self.viewFactory = viewFactory
        self.onFlowEvent = onFlowEvent
    }

    // MARK: - View Destination
    var rootView: some View {
        childView(by: .start)
    }

    @ViewBuilder
    func childView(by route: Route) -> some View {
        let _ = Log.ui.debug("Will build by route: \(route)")

        switch route {

        case .start:
            viewFactory.makeStartOnboardingView { [weak self] storeEvent in
                self?.matchStartOnboardingEvent(for: storeEvent)
            }

        case .finish:
            viewFactory.makeFinishOnboardingView { [weak self] storeEvent in
                self?.matchFinishOnboardingEvent(for: storeEvent)
            }
        }
    }
}

// MARK: - Intent Handler
extension OnboardingFlowCoordinator {

    enum Intent {
        case pushed(route: Route)
        case popped
        case poppedToRoot
        case finishedFlow
    }

    func send(_ intent: Intent) {
        switch intent {

        case .pushed(let route):
            path.append(route)

        case .popped:
            _ = path.popLast()

        case .poppedToRoot:
            path.removeAll()

        case .finishedFlow:
            onFlowEvent(.completed)
        }
        Log.ui.debug("Send intent: \(intent)")
    }
}

// MARK: - Store Event Matching
extension OnboardingFlowCoordinator {
    private func matchStartOnboardingEvent(for storeEvent: StartOnboardingStore.Event) {
        switch storeEvent {
        case .completedStart:
            send(.pushed(route: .finish))
        case .skipped:
            send(.finishedFlow)
        }
    }

    private func matchFinishOnboardingEvent(for storeEvent: FinishOnboardingStore.Event) {
        switch storeEvent {
        case .completed:
            send(.finishedFlow)
        }
    }
}
