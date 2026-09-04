//
//  RemoveNotificationUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 25.07.2026.
//

import Foundation

public protocol RemoveNotificationUseCase: Sendable {
    func execute(by status: ReminderDeliveryStatus)
}

public struct RemoveNotificationUseCaseImpl {

    private let notificationRepository: NotificationRepository

    public init(
        notificationRepository: NotificationRepository
    ) {
        self.notificationRepository = notificationRepository
    }
}

extension RemoveNotificationUseCaseImpl: RemoveNotificationUseCase {
    public func execute(by status: ReminderDeliveryStatus) {
        notificationRepository.remove(by: status)
    }
}
