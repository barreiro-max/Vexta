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

    public init(
        logOutUseCase: LogOutUseCase
    ) {
        self.logOutUseCase = logOutUseCase
    }

    func makeMainView(
        onStoreEvent: @escaping (MainStoreEvent) -> Void
    ) -> some View {
        let store = MainStore(
            logOutUseCase: logOutUseCase,
            onStoreEvent: onStoreEvent
        )
        return MainView(store: store)
    }
}
