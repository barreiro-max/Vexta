//
//  AuthViewFactory.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import SwiftUI
import Domain

@MainActor
public struct AuthViewFactory {

    private let cooldownTimerUseCase: CooldownTimerUseCase
    private let loginUseCase: LoginUseCase
    private let completeEmailVerificationUseCase: CompleteEmailVerificationUseCase
    private let sendEmailVerificationUseCase: SendEmailVerificationUseCase
    private let registerUseCase: RegisterUseCase
    private let sendPasswordResetUseCase: SendPasswordResetUseCase

    public init(
        cooldownTimerUseCase: CooldownTimerUseCase,
        loginUseCase: LoginUseCase,
        completeEmailVerificationUseCase: CompleteEmailVerificationUseCase,
        sendEmailVerificationUseCase: SendEmailVerificationUseCase,
        registerUseCase: RegisterUseCase,
        sendPasswordResetUseCase: SendPasswordResetUseCase
    ) {
        self.cooldownTimerUseCase = cooldownTimerUseCase
        self.loginUseCase = loginUseCase
        self.completeEmailVerificationUseCase = completeEmailVerificationUseCase
        self.sendEmailVerificationUseCase = sendEmailVerificationUseCase
        self.registerUseCase = registerUseCase
        self.sendPasswordResetUseCase = sendPasswordResetUseCase
    }

    func makeLoginView(
        onStoreEvent: @escaping (LoginStore.Event) -> Void
    ) -> some View {
        let store = LoginStore(
            loginUseCase: loginUseCase,
            completeEmailVerificationUseCase: completeEmailVerificationUseCase,
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

    func makeSendEmailVerificationView(
        onStoreEvent: @escaping (SendEmailVerificationStore.Event) -> Void
    ) -> some View {
        let store = SendEmailVerificationStore(
            cooldownTimerUseCase: cooldownTimerUseCase,
            sendEmailVerificationUseCase: sendEmailVerificationUseCase,
            completeEmailVerificationUseCase: completeEmailVerificationUseCase,
            onStoreEvent: onStoreEvent
        )
        return SendEmailVerificationView(store: store)
    }
}
