//
//  NotificationTriggerDataSourceImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation
import UserNotifications

final class NotificationTriggerDataSourceImpl {
    private let calendar: Calendar

    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
}

extension NotificationTriggerDataSourceImpl: NotificationTriggerDataSource {
    func makeTrigger(from type: ReminderType) -> UNNotificationTrigger? {
        switch type {
        case .afterSeconds(let seconds):
            guard seconds > 0 else { return nil }
            return UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        case .afterDays:
            guard let targetDate = date(for: type) else { return nil }
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: targetDate
            )
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        case .daily(let hour, let minute):
            let components = DateComponents(hour: hour, minute: minute)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        }
    }

    private func date(for type: ReminderType) -> Date? {
        switch type {
        case .afterSeconds(let seconds):
            guard seconds > 0 else { return nil }
            return .now.addingTimeInterval(seconds)

        case .afterDays(let days, let hour, let minute):
            guard days >= 0 else { return nil }

            guard let targetDate = calendar.date(
                byAdding: .day,
                value: days,
                to: .now
            ) else {
                return nil
            }

            return calendar.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: targetDate
            )

        case .daily(let hour, let minute):
            guard let todayTarget = calendar.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: .now
            ) else {
                return nil
            }

            if todayTarget <= .now {
                return calendar.date(byAdding: .day, value: 1, to: todayTarget)
            } else {
                return todayTarget
            }
        }

    }
}
