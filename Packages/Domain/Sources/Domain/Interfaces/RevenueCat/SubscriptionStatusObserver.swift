//
//  SubscriptionStatusObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 17.09.2026.
//

import Foundation

public protocol SubscriptionStatusObserver: Sendable {
    @MainActor var stream: AsyncStream<SubscriptionStatus> { get }
}
