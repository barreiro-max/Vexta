//
//  RevenueCatSubscriptionStatusObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 17.09.2026.
//

import Foundation
import Domain
import Telemetry
import RevenueCat

public struct RevenueCatSubscriptionStatusObserver {
    public init() {}
    private var revenueCat: Purchases { .shared }
}

extension RevenueCatSubscriptionStatusObserver: SubscriptionStatusObserver {

    public var stream: AsyncStream<SubscriptionStatus> {
        AsyncStream { continuation in
            let task = Task {
                Log.auth.debug("Stream subscription status value started")
                await observeSubscriptionStatus(with: continuation)
                continuation.finish()
                Log.auth.debug("Stream subscription status finished")
            }
            continuation.onTermination = { _ in
                task.cancel()
                Log.auth.debug("Stream subscription status stopped")
            }
        }
    }

    private func observeSubscriptionStatus(
        with continuation: AsyncStream<SubscriptionStatus>.Continuation
    ) async {
        for await customerInfo in revenueCat.customerInfoStream {
            if Task.isCancelled { break }
            let isActive = customerInfo.entitlements["Vexta Premium"]?.isActive == true
            isActive ? continuation.yield(.active) : continuation.yield(.inactive)
        }
    }
}
