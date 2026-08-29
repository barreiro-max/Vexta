//
//  AuthFlowCoordinator.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import SwiftUI
import Domain
import Telemetry

@MainActor
@Observable
public final class AuthFlowCoordinator {

    // MARK: - Nested Types
    public enum FlowEvent {
        case finished
        case alerted(error: AuthError)
    }

    enum Route: Hashable, Codable {
        case login
        case register
        case sendResetPassword
    }

    // MARK: - Path
    var path: [Route] = []

    // MARK: - Dependencies
    private let viewFactory: AuthViewFactory

    // MARK: - Event
    private let onFlowEvent: (FlowEvent) -> Void

    // MARK: - Init
    init(
        viewFactory: AuthViewFactory,
        onFlowEvent: @escaping (FlowEvent) -> Void
    ) {
        self.viewFactory = viewFactory
        self.onFlowEvent = onFlowEvent
    }

    // MARK: - View Destination
    var rootView: some View {
        chlidView(by: .login)
    }

    @ViewBuilder
    func chlidView(by route: Route) -> some View {
        switch route {
        case .login:
            viewFactory.makeLoginView() { [weak self] storeEvent in
                self?.matchLoginEvent(for: storeEvent)
            }
        case .register:
            viewFactory.makeRegisterView() { [weak self] storeEvent in
                self?.matchRegisterEvent(for: storeEvent)
            }
        case .sendResetPassword:
            viewFactory.makeSendResetPasswordView() { [weak self] storeEvent in
                self?.matchSendPasswordResetEvent(for: storeEvent)
            }
        }
    }
}

// MARK: - Intent Handler
extension AuthFlowCoordinator {
    enum Intent {
        case pushed(route: Route)
        case popped
        case poppedToRoot

        case finishedFlow
        case showAlert(with: AuthError)
    }

    func send(_ intent: Intent) {
        switch intent {
            
        case .pushed(let route):
            path.append(route)
            
        case .popped:
            _ = path.popLast()
            
        case .poppedToRoot:
            path.removeAll()
            
        case .finishedFlow:
            onFlowEvent(.finished)
            
        case .showAlert(with: let error):
            onFlowEvent(.alerted(error: error))
        }
        Log.ui.debug("Send intent: \(intent)")
    }
}

// MARK: - Store Event Matching
extension AuthFlowCoordinator {

    private func matchLoginEvent(for storeEvent: LoginStore.Event) {
        switch storeEvent {

        case .loginSucceeded:
            send(.finishedFlow)

        case .loginFailed(let error):
            send(.showAlert(with: error))

        case .registerSelected:
            send(.pushed(route: .register))

        case .sendResetPasswordSelected:
            send(.pushed(route: .sendResetPassword))
        }

    }

    private func matchRegisterEvent(for storeEvent: RegisterStore.Event) {
        switch storeEvent {
            
        case .registerSucceeded:
            send(.finishedFlow)
        case .registerFailed(let error):
            send(.showAlert(with: error))
        }
    }

    private func matchSendPasswordResetEvent(for storeEvent: SendPasswordResetStore.Event) {
        switch storeEvent {

        case .sendPasswordResetSucceeded:
            send(.popped)
        case .sendPasswordResetFailed(let error):
            send(.showAlert(with: error))
        }
    }
}
