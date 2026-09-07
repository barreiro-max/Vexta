//
//  MainView.swift
//  Vexta
//
//  Created by MaxAdmin on 29.07.2026.
//

import SwiftUI
import Domain

struct MainView: View {

    @State private var store: MainStore

    init(store: MainStore) {
        self._store = State(wrappedValue: store)
    }

    @State private var email = ""

    var body: some View {
        Text("Profile")
        Button("Log out") {
            store.send(.logOut)
        }

        TextField(
            "Enter the email...",
            text: $email
        )
        .textInputAutocapitalization(.never)

        HStack(spacing: 32) {
            VStack(spacing: 8) {
                linkButton(.email(email: email, password: "123124dsnc"))
                linkButton(.google)
                linkButton(.apple)
                linkButton(.facebook)
            }

            VStack(spacing: 8) {
                unlinkButton(.email(email: email, password: "123124dsnc"))
                unlinkButton(.google)
                unlinkButton(.apple)
                unlinkButton(.facebook)
            }
        }
    }

    private func linkButton(_ provider: LinkableAuthProviderOption) -> some View {
        Button("Link with \(provider.domain)") {
            store.send(.link(with: provider))
        }
    }

    private func unlinkButton(_ provider: LinkableAuthProviderOption) -> some View {
        Button("Unlink with \(provider.domain)") {
            store.send(.unlink(from: provider))
        }
    }
}

#Preview {
    let logOutUseCase = PreviewLogOutUseCase()
    let linkAccountUseCase = PreviewLinkAccountUseCase()
    let unlinkAccountUseCase = PreviewUnlinkAccountUseCase()

    let store = MainStore(
        logOutUseCase: logOutUseCase,
        linkAccountUseCase: linkAccountUseCase,
        unlinkAccountUseCase: unlinkAccountUseCase,
    ) { _ in }
    MainView(store: store)
}
