//
//  NotificationEventsObserverImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation
import Telemetry

public struct NotificationEventObserverImpl {
    private let notificationDelegate: NotificationDelegate

    public init(notificationDelegate: NotificationDelegate) {
        self.notificationDelegate = notificationDelegate
    }
}

extension NotificationEventObserverImpl: NotificationEventObserver {

    public var stream: AsyncStream<NotificationEvent> {
        AsyncStream { continuation in
            let task = Task {
                Log.notification.debug("Notification delegate stream started")
                await observeNotificationEvents(with: continuation)
                continuation.finish()
                Log.notification.debug("Notification delegate stream finished")
            }
            continuation.onTermination = { @Sendable _ in
                task.cancel()
                Log.notification.debug("Notification delegate stream stopped")
            }
        }
    }

    private func observeNotificationEvents(
        with continuation: AsyncStream<NotificationEvent>.Continuation
    ) async {
        for await event in notificationDelegate.stream {
            if Task.isCancelled { break }

            continuation.yield(event)
            Log.notification.debug("Stream notification events yields with: [\(String(describing: event))]")
        }
    }
}
