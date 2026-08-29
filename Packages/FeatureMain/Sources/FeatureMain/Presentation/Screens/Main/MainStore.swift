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
        case failure
    }

    enum Intent {
        case logOut
    }

    enum Event {
        case logOutTapped
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - UseCase
    private let logOutUseCase: LogOutUseCase

    // MARK: - Event
    private let onStoreEvent: (Event) -> Void

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
            logOut()
        }
    }

    // MARK: - Private Actions
    private func logOut() {
        do throws(AuthError) {
            try logOutUseCase.execute()
            state = .success
            onStoreEvent(.logOutTapped)
        } catch {
            state = .failure
        }
    }
}
