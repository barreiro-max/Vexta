//
//  NotificationDelegateImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation
import UserNotifications
import Telemetry

public final class NotificationDelegateImpl: NSObject {
    public let stream: AsyncNotificationStream

    private let continuation: AsyncNotificationStream.Continuation

    public override init() {
        let (stream, continuation) = AsyncNotificationStream.makeStream()

        self.stream = stream
        self.continuation = continuation

        super.init()
    }

    public typealias AsyncNotificationStream = AsyncStream<NotificationEvent>
}

extension NotificationDelegateImpl: NotificationDelegate {

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let event = NotificationEvent.didReceive(
            actionIdentifier: response.actionIdentifier,
            userInfo: response.notification.request.content.userInfo as? [String: Sendable] ?? [:]
        )
        await MainActor.run {
            continuation.yield(event)
        }

        Log.notification.debug("Did receive notification response with id: \(response.notification.request.identifier)")
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        let event = NotificationEvent.willPresent(
            userInfo: notification.request.content.userInfo as? [String: Sendable] ?? [:]
        )
        await MainActor.run {
            continuation.yield(event)
        }

        Log.notification.debug("Will present notification with id: \(notification.request.identifier), date: \(notification.date), repeats: \(notification.request.trigger?.repeats)")
        return [.badge, .sound, .banner, .list]
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        openSettingsFor notification: UNNotification?
    ) {
        let id = notification?.request.identifier
        if let id  {
            Log.notification.debug("Open settings for notification with id: \(id)")
        } else {
            Log.notification.debug("Open settings directly from iOS Settings app")
        }
    }
}
