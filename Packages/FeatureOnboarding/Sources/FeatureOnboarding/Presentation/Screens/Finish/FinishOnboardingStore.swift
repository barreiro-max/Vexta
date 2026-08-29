//
//  FinishOnboardingStore.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation
import Domain

@MainActor
@Observable
final class FinishOnboardingStore {

    // MARK: - Nested Types
    enum State {
        case idle
        case success
    }

    enum Intent {
        case finished
    }

    enum Event {
        case completed
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - Dependencies
    private let completeOnboardingUseCase: CompleteOnboardingUseCase

    // MARK: - Event
    private let onStoreEvent: (Event) -> Void

    // MARK: - Init
    public init(
        completeOnboardingUseCase: CompleteOnboardingUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.completeOnboardingUseCase = completeOnboardingUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .finished:
            finish()
        }
    }

    // MARK: - Private Actions
    func finish() {
        do {
            try completeOnboardingUseCase.execute()
            onStoreEvent(.completed)
        } catch {

        }
    }
}
