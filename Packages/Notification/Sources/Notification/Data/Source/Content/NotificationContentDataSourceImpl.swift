//
//  NotificationContentDataSource.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation
import UserNotifications

protocol NotificationContentDataSource: Sendable {
    func makeContent(with content: ReminderContent) -> UNMutableNotificationContent
}
