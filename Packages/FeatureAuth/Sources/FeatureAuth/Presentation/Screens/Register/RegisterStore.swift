//
//  RegisterStore.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import Foundation
import Domain

@MainActor
@Observable
final class RegisterStore {

    // MARK: - Nested Types
    enum State {
        case idle
        case loading
        case failure(error: AuthError)
        case completed(userUID: String?)
    }

    enum Intent {
        case register(email: String, password: String)
    }

    enum Event {
        case registerSucceeded
        case registerFailed(error: AuthError)
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - Dependencies
    private let registerUseCase: RegisterUseCase
    private let onStoreEvent: (Event) -> Void

    @ObservationIgnored
    private var registerTask: Task<Void, Never>?

    // MARK: - Init
    init(
        registerUseCase: RegisterUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.registerUseCase = registerUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .register(let email, let password):
            registerTask?.cancel()
            registerTask = Task { await register(email: email, password: password) }
        }
    }

    // MARK: - Private Actions
    private func register(email: String, password: String) async {
        state = .idle
        state = .loading

        do throws(AuthError) {
            let id = try await registerUseCase.execute(
                email: email,
                password: password
            )
            state = .completed(userUID: id)

            onStoreEvent(.registerSucceeded)
        } catch {
            if Task.isCancelled { return }
            state = .failure(error: error)

            onStoreEvent(.registerFailed(error: error))
        }
    }
}
