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

    var body: some View {
        Text("Send reset password")
        Button("test sending") {
            store.send(.sendPasswordReset(email: "createUser@gmail.com"))
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

