//
//  PreviewNetworkStatusObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 10.08.2026.
//

import Foundation

public struct PreviewNetworkStatusObserver: NetworkStatusObserver {
    public var isConnected: Bool

    public init(isConnected: Bool) {
        self.isConnected = isConnected
    }

    public var stream: AsyncStream<NetworkStatus> = .init { continuation in
        continuation.yield(.notConnected)
        continuation.yield(.requiresConnection)
        continuation.yield(.connected)
        continuation.finish()
    }
}

