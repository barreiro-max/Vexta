//
//  OnboardingFlowView.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import SwiftUI
import Domain

public struct OnboardingFlowView: View {

    @State private var coordinator: OnboardingFlowCoordinator

    public init(
        viewFactory: OnboardingViewFactory,
        onFlowEvent: @escaping (OnboardingFlowCoordinator.FlowEvent) -> Void
    ) {
        let coordinator = OnboardingFlowCoordinator(
            viewFactory: viewFactory,
            onFlowEvent: onFlowEvent
        )
        self._coordinator = State(wrappedValue: coordinator)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView
                .navigationDestination(for: OnboardingFlowCoordinator.Route.self) { route in
                    coordinator.childView(by: route)
                }
        }
        .animation(.default, value: coordinator.path)
    }
}

#Preview {
    let completeOnboardingUseCase = PreviewCompleteOnboardingUseCase()

    let viewFactory = OnboardingViewFactory(
        completeOnboardingUseCase: completeOnboardingUseCase
    )
    OnboardingFlowView(viewFactory: viewFactory) {_ in}
}
