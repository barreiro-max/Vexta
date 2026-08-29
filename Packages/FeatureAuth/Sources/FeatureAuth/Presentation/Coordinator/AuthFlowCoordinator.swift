//
//  AuthFlowCoordinator.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import SwiftUI
import Telemetry

@MainActor
@Observable
final class AuthFlowCoordinator {
    var path: [AuthRoute] = []

    private let viewFactory: AuthViewFactory

    private let onFlowEvent: (AuthFlowCoordinatorEvent) -> Void

    init(
        viewFactory: AuthViewFactory,
        onFlowEvent: @escaping (AuthFlowCoordinatorEvent) -> Void
    ) {
        self.viewFactory = viewFactory
        self.onFlowEvent = onFlowEvent
    }

    var rootView: some View {
        chlidView(by: .login)
    }

    @ViewBuilder
    func chlidView(by route: AuthRoute) -> some View {
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

extension AuthFlowCoordinator {
    func send(_ intent: AuthFlowCoordinatorIntent) {
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
