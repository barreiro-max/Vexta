//
//  AppAlert.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import Foundation

public struct AppAlert: Identifiable, Sendable {
    public let id = UUID()
    public let error: LocalizedError
    public let buttonActions: [AppAlertButtonAction]

    public init(
        error: LocalizedError,
        buttonActions: [AppAlertButtonAction] = [.ok()]
    ) {
        self.error = error
        self.buttonActions = buttonActions
    }
}

extension AppAlert: CustomStringConvertible {
    public var description: String {
        let buttons = buttonActions.map(\.buttonTitle).joined(separator: ", ")
        return "AppAlert(error: \(error), buttons: [\(buttons)])"
    }
}
