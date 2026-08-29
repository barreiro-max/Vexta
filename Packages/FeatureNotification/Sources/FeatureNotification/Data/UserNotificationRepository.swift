//
//  UserNotificationRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 17.07.2026.
//

import Foundation
import UserNotifications
import Telemetry

struct UserNotificationRepository {

    private var center: UNUserNotificationCenter { .current() }
}

extension UserNotificationRepository: NotificationRepository {

    func requestAuthorization() async throws -> Bool {
        do {
            return try await center
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            throw error
        }
    }

    func send(
        id: String,
        title: String,
        subtitle: String = "",
        body: String,
        categoryIdentifier: String?,
        timeInterval: TimeInterval,
        repeats: Bool = false
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = .default
        content.badge = 1
        if let categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
            Log.notification.info("Successfully scheduled local notification with id: \(id), title: \(title), categoryIdentifier: \(categoryIdentifier ?? "nil"), timeInterval: \(timeInterval), repeats: \(repeats)")
        } catch {
            Log.notification.error("Failed to add request in UserNotification center: \(error.localizedDescription)")
            throw error
        }
    }

    func send(
        id: String,
        title: String,
        subtitle: String = "",
        body: String,
        categoryIdentifier: String?,
        date: Date,
        repeats: Bool = false
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = .default
        content.badge = 1
        if let categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
            Log.notification.info("Successfully scheduled local notification with id: \(id), title: \(title), categoryIdentifier: \(categoryIdentifier ?? "nil"), date: \(date), repeats: \(repeats)")
        } catch {
            Log.notification.error("Failed to add request in UserNotification center: \(error.localizedDescription)")
            throw error
        }

    }

    func remove(notificationId: String, clearDelivered: Bool = false) {
        center.removePendingNotificationRequests(
            withIdentifiers: [notificationId]
        )
        Log.notification.notice("Removed pending notification with id: \(notificationId) from center")

        if clearDelivered {
            center.removeDeliveredNotifications(
                withIdentifiers: [notificationId]
            )
            Log.notification.notice("Removed delivered notification with id: \(notificationId) from center")
        }
    }

    func removeAll(clearDelivered: Bool = false) {
        center.removeAllPendingNotificationRequests()
        Log.notification.notice("Removed all pending notifications from UserNotification center")

        if clearDelivered {
            center.removeAllDeliveredNotifications()
            Log.notification.notice("Removed all delivered notifications from UserNotification center")
        }
    }
}
