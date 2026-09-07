//
//  NotificationEventObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation

public protocol NotificationEventObserver: Sendable {
    var stream: AsyncStream<NotificationEvent> { get }
}

