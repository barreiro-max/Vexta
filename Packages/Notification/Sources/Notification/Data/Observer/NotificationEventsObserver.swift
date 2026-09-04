//
//  NotificationEventsObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation

public protocol NotificationEventsObserver: Sendable {
    var stream: AsyncStream<NotificationEvent> { get }
}

