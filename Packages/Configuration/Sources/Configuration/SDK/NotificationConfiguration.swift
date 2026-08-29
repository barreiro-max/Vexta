//
//  AppConfigurator.swift
//  Vexta
//
//  Created by MaxAdmin on 02.07.2026.
//

import UserNotifications
import Telemetry

public protocol NotificationConfigurable: Sendable {
    func configure() async
}

public struct NotificationConfiguration: NotificationConfigurable {

    public init() {}
    
    public func configure() async {
        do {
            let center: UNUserNotificationCenter = .current()

            let granted = try await center.requestAuthorization()

            let status = await center.notificationSettings().authorizationStatus

            Log.notification.notice("🔔 Notification authorization is granted by user: \(granted), authStatus: \(status)")

        } catch {
            Log.notification.error("⛔️ Notification authorization failed with error: \(error.localizedDescription)")
            return
        }

        Log.notification.notice("🔔 Notifications configured")
    }
}

