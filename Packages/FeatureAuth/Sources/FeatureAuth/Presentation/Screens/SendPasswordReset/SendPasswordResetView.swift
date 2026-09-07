//
//  SendPasswordResetView.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import SwiftUI

struct SendPasswordResetView: View {

    @State private var store: SendPasswordResetStore

    init(store: SendPasswordResetStore) {
        _store = State(wrappedValue: store)
    }

    @State private var email = ""

    var body: some View {
        Text("Send reset password")

        TextField(
            "Enter the email...",
            text: $email
        )
        .textInputAutocapitalization(.never)

        Button("test sending") {
            store.send(.sendPasswordReset(email: email))
        }
    }
}

#Preview {
    let sendPasswordResetUseCase = PreviewSendPasswordResetUseCase()
    let store = SendPasswordResetStore(
        sendPasswordResetUseCase: sendPasswordResetUseCase,
        onStoreEvent: {_ in}
    )
    SendPasswordResetView(store: store)
}

