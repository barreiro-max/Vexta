//
//  NotificationContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 23.08.2026.
//

import Foundation

public final class NotificationContainer {
    public init() {}

    lazy var notificationRepository = UserNotificationRepository()

    public lazy var sendNotificationUseCase = SendNotificationUseCaseImpl(
        notificationRepository: notificationRepository
    )
}


