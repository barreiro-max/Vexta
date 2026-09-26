//
//  TabFlowViewFactoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 25.08.2026.
//

import SwiftUI

// MARK: - Feature imports
import FeatureMain
//import FeatureSearch
//import FeatureCart
//import FeatureProfile

@MainActor
protocol TabFlowViewFactory {
    func makeMainFlowView(
        onFlowEvent: @escaping (MainFlowCoordinator.FlowEvent) -> Void
    ) -> MainFlowView

    func makeCartFlowView() -> Text

    func makeSearchFlowView() -> Text

    func makeProfileFlowView() -> Text
}

@MainActor
struct TabFlowViewFactoryImpl {
    private let mainViewFactory: MainViewFactory

    init(mainViewFactory: MainViewFactory) {
        self.mainViewFactory = mainViewFactory
    }
}

extension TabFlowViewFactoryImpl: TabFlowViewFactory {
    func makeMainFlowView(
        onFlowEvent: @escaping (MainFlowCoordinator.FlowEvent) -> Void
    ) -> MainFlowView {
        MainFlowView(
            viewFactory: mainViewFactory,
            onFlowEvent: onFlowEvent
        )
    }

    func makeCartFlowView() -> Text {
        Text("Cart")
    }

    func makeSearchFlowView() -> Text {
        Text("Search")
    }

    func makeProfileFlowView() -> Text {
        Text("Profile")
    }
}

