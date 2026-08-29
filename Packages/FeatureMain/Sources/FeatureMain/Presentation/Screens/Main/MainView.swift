//
//  MainView.swift
//  Vexta
//
//  Created by MaxAdmin on 29.07.2026.
//

import SwiftUI

struct MainView: View {

    @State private var store: MainStore

    init(store: MainStore) {
        self._store = State(wrappedValue: store)
    }

    var body: some View {
        Text("Profile")
        Button("Log out") {
            store.send(.logOut)
        }
    }
}

#Preview {
    let logOutUseCase = PreviewLogOutUseCase()
    let store = MainStore(logOutUseCase: logOutUseCase) { _ in }
    MainView(store: store)
}
