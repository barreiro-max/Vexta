//
//  ProfileStore.swift
//  Vexta
//
//  Created by MaxAdmin on 29.07.2026.
//

import Foundation
import Domain

@MainActor
@Observable
final class MainStore {

    // MARK: - Nested Types
    enum State {
        case idle
        case success
        case failure(error: AccountError)
    }

    enum Intent {
        case logOut
    }

    enum Event {
        case logOutSucceeded
        case logOutFailed(error: AccountError)
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - UseCase
    private let logOutUseCase: LogOutUseCase

    // MARK: - Event
    private let onStoreEvent: (Event) -> Void

    @ObservationIgnored
    private var logOutTask: Task<Void, Never>?

    // MARK: - Init
    init(
        logOutUseCase: LogOutUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.logOutUseCase = logOutUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .logOut:
            logOutTask?.cancel()
            logOutTask = Task { await logOut() }
        }
    }

    // MARK: - Private Actions
    private func logOut() async {
        do throws(AccountError) {
            try await logOutUseCase.execute()
            if Task.isCancelled { return }

            state = .success
            onStoreEvent(.logOutSucceeded)
        } catch {
            if Task.isCancelled { return }
            state = .failure(error: error)
            onStoreEvent(.logOutFailed(error: error))
        }
    }
}
