//
//  NotificationDelegate.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation
import UserNotifications

public protocol NotificationDelegate: @MainActor UNUserNotificationCenterDelegate, Sendable {
    var stream: AsyncStream<NotificationEvent> { get }
}
