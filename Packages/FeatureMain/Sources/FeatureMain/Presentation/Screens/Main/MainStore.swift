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
    enum State: Equatable {
        case idle
        case loading
        case completed
        case failure(error: AccountError)

        var isLoading: Bool {
            if case .loading = self { true } else { false }
        }
    }

    enum Intent {
        case logOut
        case link(with: LinkableAuthProviderOption)
        case unlink(from: LinkableAuthProviderOption)
    }

    enum Event {
        case logOutSucceeded
        case logOutFailed(error: AccountError)

        case linkSucceeded
        case linkFailed(error: AccountError)

        case unlinkSucceeded
        case unlinkFailed(error: AccountError)
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - UseCase
    private let logOutUseCase: LogOutUseCase
    private let linkAccountUseCase: LinkAccountUseCase
    private let unlinkAccountUseCase: UnlinkAccountUseCase

    // MARK: - Event
    private let onStoreEvent: (Event) -> Void

    @ObservationIgnored
    private var logOutTask: Task<Void, Never>?

    @ObservationIgnored
    private var linkTask: Task<Void, Never>?

    @ObservationIgnored
    private var unlinkTask: Task<Void, Never>?

    // MARK: - Init
    init(
        logOutUseCase: LogOutUseCase,
        linkAccountUseCase: LinkAccountUseCase,
        unlinkAccountUseCase: UnlinkAccountUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.logOutUseCase = logOutUseCase
        self.linkAccountUseCase = linkAccountUseCase
        self.unlinkAccountUseCase = unlinkAccountUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .logOut:
            logOutTask?.cancel()
            logOutTask = Task { await logOut() }
        case .link(let linkableProvider):
            linkTask?.cancel()
            linkTask = Task { await link(with: linkableProvider) }
        case .unlink(let linkableProvider):
            unlinkTask?.cancel()
            unlinkTask = Task { await unlink(from: linkableProvider) }
        }
    }

    // MARK: - Private Actions
    private func logOut() async {
        guard !state.isLoading else { return }
        state = .idle
        state = .loading

        do throws(AccountError) {
            try await logOutUseCase.execute()
            if Task.isCancelled { return }

            state = .completed
            onStoreEvent(.logOutSucceeded)
        } catch {
            if Task.isCancelled { return }
            state = .failure(error: error)
            onStoreEvent(.logOutFailed(error: error))
        }
    }

    private func link(with provider: LinkableAuthProviderOption) async {
        guard !state.isLoading else { return }
        state = .idle
        state = .loading

        do throws(AccountError) {
            let uid = try await linkAccountUseCase.execute(with: provider)
            if Task.isCancelled { return }

            state = .completed
            onStoreEvent(.linkSucceeded)
        } catch {
            if Task.isCancelled { return }
            state = .failure(error: error)
            onStoreEvent(.linkFailed(error: error))
        }
    }

    private func unlink(from provider: LinkableAuthProviderOption) async {
        guard !state.isLoading else { return }
        state = .idle
        state = .loading

        do throws(AccountError) {
            let uid = try await unlinkAccountUseCase.execute(from: provider)
            if Task.isCancelled { return }

            state = .completed
            onStoreEvent(.unlinkSucceeded)
        } catch {
            if Task.isCancelled { return }
            state = .failure(error: error)
            onStoreEvent(.unlinkFailed(error: error))
        }
    }
}
