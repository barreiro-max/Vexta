//
//  SendPasswordResetStore.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import Foundation
import Domain

@MainActor
@Observable
final class SendPasswordResetStore {

    // MARK: - Nested Types
    enum State {
        case idle
        case loading
        case failure(error: AuthError)
        case completed
    }

    enum Intent {
        case sendPasswordReset(email: String)
    }

    enum Event {
        case sendPasswordResetSucceeded
        case sendPasswordResetFailed(error: AuthError)
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - Dependencies
    private let sendPasswordResetUseCase: SendPasswordResetUseCase
    private let onStoreEvent: (Event) -> Void

    @ObservationIgnored
    private var sendPasswordResetTask: Task<Void, Never>?

    // MARK: - Init
    init(
        sendPasswordResetUseCase: SendPasswordResetUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.sendPasswordResetUseCase = sendPasswordResetUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .sendPasswordReset(let email):
            sendPasswordResetTask?.cancel()
            sendPasswordResetTask = Task { await sendPasswordReset(with: email) }
        }
    }

    // MARK: - Private Actions
    private func sendPasswordReset(with email: String) async {
        state = .idle
        state = .loading

        do throws(AuthError) {
            try await sendPasswordResetUseCase.execute(email: email)
            if Task.isCancelled { return }

            state = .completed
            onStoreEvent(.sendPasswordResetSucceeded)
        } catch {
            if Task.isCancelled { return }
            state = .failure(error: error)

            onStoreEvent(.sendPasswordResetFailed(error: error))
        }
    }
}
