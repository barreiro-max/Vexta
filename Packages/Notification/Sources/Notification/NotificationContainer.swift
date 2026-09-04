//
//  NotificationContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 23.08.2026.
//

import Foundation
import UserNotifications

public final class NotificationContainer {

    public let notificationDelegate = NotificationDelegateImpl()

    public init() {}

    private lazy var notificationContentDataSource = NotificationContentDataSourceImpl()

    private lazy var notificationTriggerDataSource = NotificationTriggerDataSourceImpl(
        calendar: .current
    )

    private lazy var notificationRepository = UserNotificationRepository(
        notificationTriggerDataSource: notificationTriggerDataSource,
        notificationContentDataSource: notificationContentDataSource
    )

    public lazy var scheduleNotificationUseCase = ScheduleNotificationUseCaseImpl(
        notificationRepository: notificationRepository
    )

    public lazy var removeNotificationUseCase = RemoveNotificationUseCaseImpl(
        notificationRepository: notificationRepository
    )

    public lazy var notificationEventsObserver = NotificationEventsObserverImpl(
        notificationDelegate: notificationDelegate
    )
}
