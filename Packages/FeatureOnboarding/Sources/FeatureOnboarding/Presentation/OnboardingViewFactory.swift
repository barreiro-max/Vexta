//
//  OnboardingViewFactory.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation
import Domain

@MainActor
public struct OnboardingViewFactory {

    private let completeOnboardingUseCase: CompleteOnboardingUseCase

    public init(
        completeOnboardingUseCase: CompleteOnboardingUseCase
    ) {
        self.completeOnboardingUseCase = completeOnboardingUseCase
    }

    func makeStartOnboardingView(
        onStoreEvent: @escaping (StartOnboardingStore.Event) -> Void
    ) -> StartOnboardingView {
        let store = StartOnboardingStore(
            completeOnboardingUseCase: completeOnboardingUseCase,
            onStoreEvent: onStoreEvent
        )
        return StartOnboardingView(store: store)
    }

    func makeFinishOnboardingView(
        onStoreEvent: @escaping (FinishOnboardingStore.Event) -> Void
    ) -> FinishOnboardingView {
        let store = FinishOnboardingStore(
            completeOnboardingUseCase: completeOnboardingUseCase,
            onStoreEvent: onStoreEvent
        )
        return FinishOnboardingView(store: store)
    }
}
