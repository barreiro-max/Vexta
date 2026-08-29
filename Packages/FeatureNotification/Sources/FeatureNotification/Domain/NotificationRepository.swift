//
//  NotificationRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol NotificationRepository {
    func requestAuthorization() async throws -> Bool
    
    func send(
        id: String,
        title: String,
        subtitle: String,
        body: String,
        categoryIdentifier: String?,
        timeInterval: TimeInterval,
        repeats: Bool
    ) async throws

    func send(
        id: String,
        title: String,
        subtitle: String,
        body: String,
        categoryIdentifier: String?,
        date: Date,
        repeats: Bool
    ) async throws

    func remove(
        notificationId: String,
        clearDelivered: Bool
    )

    func removeAll(clearDelivered: Bool)
}
