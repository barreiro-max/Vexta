//
//  StartOnboardingStore.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import Foundation
import Domain

@MainActor
@Observable
final class StartOnboardingStore {

    // MARK: - Nested Types
    enum State {
        case idle
        case completed
    }

    enum Intent {
        case nextPage
        case skip
    }

    enum Event {
        case completedStart
        case skipped
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - Dependencies
    private let completeOnboardingUseCase: CompleteOnboardingUseCase

    // MARK: - Event
    private let onStoreEvent: (Event) -> Void

    // MARK: - Init
    init(
        completeOnboardingUseCase: CompleteOnboardingUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.completeOnboardingUseCase = completeOnboardingUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .nextPage:
            start()
        case .skip:
            skip()
        }
    }

    // MARK: - Private Actions
    private func start() {
        onStoreEvent(.completedStart)
    }
    private func skip() {
        onStoreEvent(.skipped)
    }
}
