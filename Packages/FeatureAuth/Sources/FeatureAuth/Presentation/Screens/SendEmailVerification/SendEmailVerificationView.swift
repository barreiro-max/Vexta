//
//  SendEmailVerificationView.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import SwiftUI
import Domain

struct SendEmailVerificationView: View {

    @State private var store: SendEmailVerificationStore

    init(store: SendEmailVerificationStore) {
        self._store = State(wrappedValue: store)
    }

    var body: some View {
        VStack(spacing: 16) {
            switch store.state {

            case .idle:
                Text("Email verification idle state")

            case .loading(let operation):
                Text("Loading for operation: \(operation)")

            case .failure(let operation, let error):
                Text("Failure for operation: \(operation), error: \(error)")

            case .completed(let operation):
                Text("Completed for operation: \(operation)")
            }

            if store.isCooldownActive {
                Text("Send again email verification after \(store.cooldownSeconds) seconds")
                    .transition(.opacity)
            }

            Button("Verify Email") {
                store.send(.sendEmailVerification)
            }
            .disabled(store.isCooldownActive)

            Button("Verified?") {
                store.send(.checkEmailVerification)
            }
        }
    }
}

#Preview {
    let cooldownTimerUseCase = PreviewCooldownTimerUseCase()
    let sendEmailVerificationUseCase = PreviewSendEmailVerificationUseCase()
    let completeEmailVerificationUseCase = PreviewCompleteEmailVerificationUseCase()
    let store = SendEmailVerificationStore(
        cooldownTimerUseCase: cooldownTimerUseCase,
        sendEmailVerificationUseCase: sendEmailVerificationUseCase,
        completeEmailVerificationUseCase: completeEmailVerificationUseCase,
        onStoreEvent: { _ in }
    )
    SendEmailVerificationView(store: store)
}

