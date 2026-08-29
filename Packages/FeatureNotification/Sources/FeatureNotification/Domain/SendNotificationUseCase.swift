//
//  SendNotificationUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 25.07.2026.
//

import Foundation

public protocol SendNotificationUseCase {
    func sendNonRepeatableNotification() async throws
}

public struct SendNotificationUseCaseImpl: SendNotificationUseCase {

    private let notificationRepository: NotificationRepository

    public init(
        notificationRepository: NotificationRepository
    ) {
        self.notificationRepository = notificationRepository
    }

    public func sendNonRepeatableNotification() async throws {
        try await notificationRepository.send(
            id: UUID().uuidString,
            title: "First notification",
            subtitle: "Subtitle for first notification",
            body: "Body for first notification",
            categoryIdentifier: nil,
            timeInterval: 60,
            repeats: false
        )
    }
}
