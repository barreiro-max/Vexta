//
//  ScheduleNotificationUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 25.07.2026.
//

import Foundation

public protocol ScheduleNotificationUseCase: Sendable {
    func execute(with content: ReminderContent) async throws(NotificationError)
}

public struct ScheduleNotificationUseCaseImpl {

    private let notificationRepository: NotificationRepository

    public init(
        notificationRepository: NotificationRepository
    ) {
        self.notificationRepository = notificationRepository
    }
}

extension ScheduleNotificationUseCaseImpl: ScheduleNotificationUseCase {
    public func execute(with content: ReminderContent) async throws(NotificationError) {
        do throws(NotificationError) {
            try await notificationRepository.schedule(with: content)
        } catch {
            throw error
        }
    }
}
