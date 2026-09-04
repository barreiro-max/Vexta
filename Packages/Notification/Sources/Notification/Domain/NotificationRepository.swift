//
//  NotificationRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol NotificationRepository: Sendable {
    func schedule(with content: ReminderContent) async throws(NotificationError)
    func remove(by status: ReminderDeliveryStatus)
}
