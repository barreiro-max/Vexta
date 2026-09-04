//
//  NotificationContentDataSourceImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation
import UserNotifications
import Telemetry

struct NotificationContentDataSourceImpl {}

extension NotificationContentDataSourceImpl: NotificationContentDataSource {
    func makeContent(with content: ReminderContent) -> UNMutableNotificationContent {
        let mutable = UNMutableNotificationContent()
        mutable.title = content.title
        mutable.subtitle = content.subtitle
        mutable.body = content.body
        mutable.sound = .default
        mutable.badge = 1

        if let url = content.attachmentURL {
            let identifier = content.attachmentIdentifier ?? UUID().uuidString

            if let attachment = try? UNNotificationAttachment(identifier: identifier, url: url) {
                mutable.attachments = [attachment]
            } else {
                Log.notification.warning("Attachment could not be attached from URL: \(url.path)")
            }
        }
        return mutable
    }
}
