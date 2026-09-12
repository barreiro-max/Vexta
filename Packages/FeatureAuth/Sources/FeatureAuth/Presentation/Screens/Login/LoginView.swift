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

    @State private var email = ""

    var body: some View {
        VStack(spacing: 8) {
            switch store.state {

            case .idle:
                Text("User didn't tap anything")

            case .loading(let operation):
                Text("Loading for provider operation: \(operation)")

            case .failure(let operation, let error):
                Text("Failure for: \(operation), error: \(error)")

            case .completed(let operation, let userUID):
                Text("Completed for: \(operation), userId: \(userUID)")
            }

            loginButton(with: .anonymous)

            TextField(
                "Enter the email...",
                text: $email
            )
            .textInputAutocapitalization(.never)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)

            VStack(spacing: 8) {
                loginButton(with: .email(email: email, password: "123124dsnc"))
                loginButton(with: .google)
                loginButton(with: .apple)
                loginButton(with: .facebook)
            }
            .buttonStyle(.borderedProminent)
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

#Preview {
    let loginUseCase = PreviewLoginUseCase()
    let completeEmailVerificationUseCase = PreviewCompleteEmailVerificationUseCase()
    let store = LoginStore(
        loginUseCase: loginUseCase,
        completeEmailVerificationUseCase: completeEmailVerificationUseCase,
        onStoreEvent: {_ in}
    )
    LoginView(store: store)
}
