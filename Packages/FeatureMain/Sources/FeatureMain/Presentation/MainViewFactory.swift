//
//  MainViewFactory.swift
//  Vexta
//
//  Created by MaxAdmin on 29.07.2026.
//

import SwiftUI

@MainActor
public struct MainViewFactory {

    private let logOutUseCase: LogOutUseCase
    private let userAnonymousUseCase: UserAnonymousUseCase
    private let deleteAccountUseCase: DeleteAccountUseCase

    public init(
        logOutUseCase: LogOutUseCase,
        userAnonymousUseCase: UserAnonymousUseCase,
        deleteAccountUseCase: DeleteAccountUseCase,
    ) {
        self.logOutUseCase = logOutUseCase
        self.userAnonymousUseCase = userAnonymousUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
    }

    func makeMainView(
        onStoreEvent: @escaping (MainStore.Event) -> Void
    ) -> some View {
        let store = MainStore(
            logOutUseCase: logOutUseCase,
            onStoreEvent: onStoreEvent
        )
        return MainView(store: store)
    }
}
