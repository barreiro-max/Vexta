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
    private let notificationTriggerDataSource: NotificationTriggerDataSource
    private let notificationContentDataSource: NotificationContentDataSource

    public init(
        notificationTriggerDataSource: NotificationTriggerDataSource,
        notificationContentDataSource: NotificationContentDataSource
    ) {
        self.notificationTriggerDataSource = notificationTriggerDataSource
        self.notificationContentDataSource = notificationContentDataSource
    }

    private var center: UNUserNotificationCenter { .current() }
}

extension UserNotificationRepository: NotificationRepository {

    public func schedule(with reminder: ReminderContent) async throws(NotificationError) {
        guard await isGranted else {
            throw .accessDenied
        }

        guard let trigger = notificationTriggerDataSource.makeTrigger(
            from: reminder.type
        ) else {
            throw .invalidTrigger
        }

        let notificationContent = notificationContentDataSource.makeContent(with: reminder)

        let request = UNNotificationRequest(
            identifier: reminder.id,
            content: notificationContent,
            trigger: trigger
        )

        do {
            try await center.add(request)
            Log.notification.info("Successfully scheduled local notification with id: \(reminder.id), type: \(reminder.type), repeats: \(reminder.isRepeats)")
        } catch {
            Log.notification.error("Failed to add request with id: \(request.identifier) in UserNotification center")
            throw .failureAddedRequest
        }
    }

    public func remove(by deliveryStatus: ReminderDeliveryStatus) {
        switch deliveryStatus {

        case .pending(let ids):
            center.removePendingNotificationRequests(withIdentifiers: ids)

        case .delivered(let ids):
            center.removeDeliveredNotifications(withIdentifiers: ids)

        case .allPending:
            center.removeAllPendingNotificationRequests()

        case .allDelivered:
            center.removeAllDeliveredNotifications()

        case .all:
            remove(by: .allPending)
            remove(by: .allDelivered)
        }

        Log.notification.notice("Removed \(deliveryStatus) notification from center")
    }

    private var isGranted: Bool {
        get async {
            let status = await center.notificationSettings().authorizationStatus

            return switch status {
            case .authorized, .ephemeral, .provisional: true
            case .denied, .notDetermined:               false
            @unknown default:                           false
            }
        }
    }
}
