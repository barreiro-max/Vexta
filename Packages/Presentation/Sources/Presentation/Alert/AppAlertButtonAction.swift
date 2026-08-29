//
//  AppAlertButtonAction.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation

public struct AppAlertButtonAction: Identifiable, Sendable {
    public let id = UUID()
    public let buttonTitle: String
    public let buttonRole: AppAlertButtonRole
    public let action: (@MainActor () async -> Void)?

    public init(
        buttonTitle: String,
        buttonRole: AppAlertButtonRole,
        action: (@MainActor () async -> Void)? = nil
    ) {
        self.buttonTitle = buttonTitle
        self.buttonRole = buttonRole
        self.action = action
    }

    public static func retry(onAction: (@MainActor () async -> Void)?) -> Self {
        .init(buttonTitle: "Retry", buttonRole: .retry, action: onAction)
    }

    public static func ok(onAction: (@MainActor () async -> Void)? = nil) -> Self {
        .init(buttonTitle: "OK", buttonRole: .ok, action: onAction)
    }

    public static func cancel(onAction: (@MainActor () async -> Void)? = nil) -> Self {
        .init(buttonTitle: "Cancel", buttonRole: .cancel, action: onAction)
    }

    public static func update(onAction: (@MainActor () async -> Void)? = nil) -> Self {
        .init(buttonTitle: "Update", buttonRole: .ok, action: onAction)
    }
}
