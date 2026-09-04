//
//  VextaApp.swift
//  Vexta
//
//  Created by MaxAdmin on 14.06.2026.
//

import SwiftUI
import Telemetry
import Environment
import Notification

@main
struct VextaApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    private let rootCoordinator: RootCoordinator
    private let rootContainer: RootContainer

    init() {
        rootContainer = RootContainer()
        rootCoordinator = rootContainer.makeRootCoordinator()
        configureAppDelegate()

        Log.system.notice(
            "Composition Root initialized " +
            "with environment: [\(AppEnvironment.current)]"
        )
    }

    var body: some Scene {
        WindowGroup {
            RootFlowView(coordinator: rootCoordinator)
        }
    }

    private func configureAppDelegate() {
        delegate.configContainer = rootContainer.configContainer
        delegate.notificationContainer = rootContainer.notificationContainer
    }
}
