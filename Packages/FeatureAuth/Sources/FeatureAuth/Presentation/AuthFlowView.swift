//
//  AuthFlowView.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import SwiftUI
import Domain

public struct AuthFlowView: View {

    @State private var coordinator: AuthFlowCoordinator

    public init(
        viewFactory: AuthViewFactory,
        onFlowEvent: @escaping (AuthFlowCoordinator.FlowEvent) -> Void
    ) {
        let coordinator = AuthFlowCoordinator(
            viewFactory: viewFactory,
            onFlowEvent: onFlowEvent
        )

        _coordinator = State(wrappedValue: coordinator)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView
                .navigationDestination(for: AuthFlowCoordinator.Route.self) { route in
                    coordinator.chlidView(by: route)
                }
        }
        .animation(.default, value: coordinator.path)
    }
}

#Preview {
    let cooldownTimerUseCase = PreviewCooldownTimerUseCase()
    let loginUseCase = PreviewLoginUseCase()
    let completeEmailVerificationUseCase = PreviewCompleteEmailVerificationUseCase()
    let sendEmailVerificationUseCase = PreviewSendEmailVerificationUseCase()
    let registerUseCase = PreviewRegisterUseCase()
    let sendPasswordResetUseCase = PreviewSendPasswordResetUseCase()
    let viewFactory = AuthViewFactory(
        cooldownTimerUseCase: cooldownTimerUseCase,
        loginUseCase: loginUseCase,
        completeEmailVerificationUseCase: completeEmailVerificationUseCase,
        sendEmailVerificationUseCase: sendEmailVerificationUseCase,
        registerUseCase: registerUseCase,
        sendPasswordResetUseCase: sendPasswordResetUseCase
    )
    AuthFlowView(viewFactory: viewFactory) { _ in }
}

