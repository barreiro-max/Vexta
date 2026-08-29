//
//  RootCoordinatorIntent.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation
import Presentation

enum RootCoordinatorIntent: Sendable {
    case presentedRoute(_ route: RootRoute)

    case presentedSheet(_ sheet: RootSheet)
    case dismissedSheet

    case presentedAlert(_ alert: AppAlert)
    case dismissedAlert
}
