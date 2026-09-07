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
    private let linkAccountUseCase: LinkAccountUseCase
    private let unlinkAccountUseCase: UnlinkAccountUseCase

    public init(
        logOutUseCase: LogOutUseCase,
        userAnonymousUseCase: UserAnonymousUseCase,
        deleteAccountUseCase: DeleteAccountUseCase,
        linkAccountUseCase: LinkAccountUseCase,
        unlinkAccountUseCase: UnlinkAccountUseCase,
    ) {
        self.logOutUseCase = logOutUseCase
        self.userAnonymousUseCase = userAnonymousUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
        self.linkAccountUseCase = linkAccountUseCase
        self.unlinkAccountUseCase = unlinkAccountUseCase
    }

    func makeMainView(
        onStoreEvent: @escaping (MainStore.Event) -> Void
    ) -> some View {
        let store = MainStore(
            logOutUseCase: logOutUseCase,
            linkAccountUseCase: linkAccountUseCase,
            unlinkAccountUseCase: unlinkAccountUseCase,
            onStoreEvent: onStoreEvent
        )
        return MainView(store: store)
    }
}
