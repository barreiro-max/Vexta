//
//  PreviewNetworkMonitor.swift
//  Vexta
//
//  Created by MaxAdmin on 10.08.2026.
//

import Foundation

public struct PreviewNetworkMonitor: NetworkMonitor {
    public var isConnected: Bool

    public init(isConnected: Bool) {
        self.isConnected = isConnected
    }

    public var streamConnection: AsyncStream<NetworkStatus> = .init { continuation in
        continuation.yield(.notConnected)
        continuation.yield(.requiresConnection)
        continuation.yield(.connected)
        continuation.finish()
    }
}

