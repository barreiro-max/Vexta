//
//  AuthViewFactory.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import SwiftUI

@MainActor
public struct AuthViewFactory {

    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let sendPasswordResetUseCase: SendPasswordResetUseCase

    public init(
        loginUseCase: LoginUseCase,
        registerUseCase: RegisterUseCase,
        sendPasswordResetUseCase: SendPasswordResetUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.sendPasswordResetUseCase = sendPasswordResetUseCase
    }

    func makeLoginView(
        onStoreEvent: @escaping (LoginStore.Event) -> Void
    ) -> some View {
        let store = LoginStore(
            loginUseCase: loginUseCase,
            onStoreEvent: onStoreEvent
        )
        return LoginView(store: store)
    }
    
    func makeRegisterView(
        onStoreEvent: @escaping (RegisterStore.Event) -> Void
    ) -> some View {
        let store = RegisterStore(
            registerUseCase: registerUseCase,
            onStoreEvent: onStoreEvent
        )
        return RegisterView(store: store)
    }
    
    func makeSendResetPasswordView(
        onStoreEvent: @escaping (SendPasswordResetStore.Event) -> Void
    ) -> some View {
        let store = SendPasswordResetStore(
            sendPasswordResetUseCase: sendPasswordResetUseCase,
            onStoreEvent: onStoreEvent
        )
        return SendPasswordResetView(store: store)
    }
}
