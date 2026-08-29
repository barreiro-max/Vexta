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

    // MARK: - State
    private(set) var state: MainStoreState = .idle

    // MARK: - UseCase
    private let logOutUseCase: LogOutUseCase

    // MARK: - Event
    private let onStoreEvent: (MainStoreEvent) -> Void

    init(
        logOutUseCase: LogOutUseCase,
        onStoreEvent: @escaping (MainStoreEvent) -> Void
    ) {
        self.logOutUseCase = logOutUseCase
        self.onStoreEvent = onStoreEvent
    }

    func checkProfile() {
        fatalError("not implemented")
    }

    func logOutTapped() {
        do throws(AuthError) {
            try logOutUseCase.execute()
            state = .success
            onStoreEvent(.logOutTapped)
        } catch {
            state = .failure
        }
    }
}
