//
//  NotificationTriggerDataSource.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation
import UserNotifications

protocol NotificationTriggerDataSource: Sendable {
    func makeTrigger(from type: ReminderType) -> UNNotificationTrigger?
}
