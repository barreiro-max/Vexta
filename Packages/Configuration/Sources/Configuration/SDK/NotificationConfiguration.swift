//
//  AppConfigurator.swift
//  Vexta
//
//  Created by MaxAdmin on 02.07.2026.
//

import Foundation
import UserNotifications

// MARK: - Shared imports
import Telemetry

public protocol NotificationConfigurable: Sendable {
    func configure() async
}

public struct NotificationConfiguration: NotificationConfigurable {

    public init() {}
    
    public func configure() async {
        do {
            let center: UNUserNotificationCenter = .current()

            let options: UNAuthorizationOptions = [
                .alert,
                .badge,
                .sound,
                .providesAppNotificationSettings // TODO: — implement notification settings screen in settings
            ]
            let granted = try await center.requestAuthorization(options: options)

            Log.notification.notice("🔔 Notification authorization is granted by user: \(granted)")

        } catch {
            Log.notification.error("⛔️ Notification authorization failed with error: \(error.localizedDescription)")
            return
        }

        Log.notification.notice("🔔 Notifications configured")
    }
}

