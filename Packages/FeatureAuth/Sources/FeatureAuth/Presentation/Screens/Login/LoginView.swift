//
//  LoginView.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import SwiftUI
import Domain

struct LoginView: View {

    @State private var store: LoginStore

    init(store: LoginStore) {
        _store = State(wrappedValue: store)
    }

    var body: some View {
        VStack(spacing: 8) {
            loginButton(with: .email(email: "test_email@gmail.com", password: "password"))
            loginButton(with: .google)
            loginButton(with: .apple)
            loginButton(with: .facebook)
        }

        HStack(spacing: 16) {
            Button("Sign Up") { store.send(.showRegister) }
            Button("Forget password?") { store.send(.showSendResetPassword) }
        }
        .buttonStyle(.borderedProminent)
    }

    private func loginButton(with provider: AuthProviderOption) -> some View {
        Button("Login with \(provider.title)") {
            store.send(.login(provider: provider))
        }
    }
}
