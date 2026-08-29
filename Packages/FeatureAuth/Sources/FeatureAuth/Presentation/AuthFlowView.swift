//
//  AuthFlowView.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import SwiftUI

public struct AuthFlowView: View {

    @State private var coordinator: AuthFlowCoordinator

    public init(
        viewFactory: AuthViewFactory,
        onFlowEvent: @escaping (AuthFlowCoordinatorEvent) -> Void
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
                .navigationDestination(for: AuthRoute.self) { route in
                    coordinator.chlidView(by: route)
                }
        }
        .animation(.default, value: coordinator.path)
    }
}

#Preview {
    let loginUseCase = PreviewLoginUseCase()
    let registerUseCase = PreviewRegisterUseCase()
    let sendPasswordResetUseCase = PreviewSendPasswordResetUseCase()
    let viewFactory = AuthViewFactory(
        loginUseCase: loginUseCase,
        registerUseCase: registerUseCase,
        sendPasswordResetUseCase: sendPasswordResetUseCase
    )
    AuthFlowView(viewFactory: viewFactory) { _ in }
}

