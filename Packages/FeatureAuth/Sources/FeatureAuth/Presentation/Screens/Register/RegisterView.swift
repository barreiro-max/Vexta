//
//  RegisterView.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import SwiftUI

struct RegisterView: View {

    @State private var store: RegisterStore

    init(store: RegisterStore) {
        _store = State(wrappedValue: store)
    }

    @State private var email = ""

    var body: some View {
        Text("Register")

        TextField(
            "Enter the email...",
            text: $email
        )
        .textInputAutocapitalization(.never)

        Button("Register with test credentials") {
            store.send(.register(email: email, password: "123124dsnc"))
        }
    }
}

#Preview {
    let registerUseCase = PreviewRegisterUseCase()
    let store = RegisterStore(registerUseCase: registerUseCase) { _ in }
    RegisterView(store: store)
}
