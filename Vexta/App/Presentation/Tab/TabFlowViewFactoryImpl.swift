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

protocol TabFlowViewFactory {
    func makeMainFlowView(
        onFlowEvent: @escaping (MainFlowCoordinator.FlowEvent) -> Void
    ) -> MainFlowView

    func makeCartFlowView() -> EmptyView

    func makeSearchFlowView() -> EmptyView

    func makeProfileFlowView() -> EmptyView
}

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

    func makeCartFlowView() -> EmptyView {
        EmptyView()
    }

    func makeSearchFlowView() -> EmptyView {
        EmptyView()
    }

    func makeProfileFlowView() -> EmptyView {
        EmptyView()
    }
}

