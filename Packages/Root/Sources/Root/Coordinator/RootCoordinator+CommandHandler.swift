//
//  RootCoordinator+CommandHandler.swift
//  Vexta
//
//  Created by MaxAdmin on 26.09.2026.
//

import Foundation

// MARK: - Shared imports
import Presentation
import Telemetry

extension RootCoordinator {

    enum Command {
        case lock(reason: String)
        case unlock(with: Route)
    }

    func execute(_ command: Command) {
        self.rootSheet = nil

        switch command {
        case .unlock(let route):
            if rootRoute.isLock {
                self.rootRoute = route
            }

        case .lock(let reason):
            self.rootRoute = .lock(reason: reason)
        }

        Log.ui.warning("Send command: \(command)")
    }
}
