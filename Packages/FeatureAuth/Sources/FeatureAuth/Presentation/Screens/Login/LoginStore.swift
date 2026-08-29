//
//  LoginStore.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import Foundation
import Domain

@MainActor
@Observable
final class LoginStore {

    // MARK: - Nested Types
    enum State {
        case idle
        case loading
        case failure(error: AuthError)
        case completed(userUID: String?)
    }

    enum Intent {
        case login(provider: AuthProviderOption)
        case showRegister
        case showSendResetPassword
    }

    enum Event {
        case loginSucceeded
        case loginFailed(error: AuthError)
        case registerSelected
        case sendResetPasswordSelected
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - Dependencies
    private let loginUseCase: LoginUseCase
    private let onStoreEvent: (Event) -> Void

    @ObservationIgnored
    private var loginTask: Task<Void, Never>?

    // MARK: - Init
    init(
        loginUseCase: LoginUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.loginUseCase = loginUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .login(let provider):
            loginTask?.cancel()
            loginTask = Task { await login(with: provider) }
        case .showRegister:
            registerSelected()
        case .showSendResetPassword:
            showSendResetPassword()
        }
    }

    // MARK: - Private Actions
    private func login(with provider: AuthProviderOption) async {
        state = .idle
        state = .loading

        do throws(AuthError) {
            let id = try await loginUseCase.execute(with: provider)
            state = .completed(userUID: id)
            onStoreEvent(.loginSucceeded)
        } catch {
            if Task.isCancelled { return }
            state = .failure(error: error)
            onStoreEvent(.loginFailed(error: error))
        }
    }

    private func registerSelected() {
        onStoreEvent(.registerSelected)
    }

    private func showSendResetPassword() {
        onStoreEvent(.sendResetPasswordSelected)
    }
}
