//
//  NWPathNetworkMonitor.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Network
import Domain
import Telemetry

public struct NWPathNetworkMonitor: NetworkMonitor {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NWPathNetworkMonitor")
    
    public init(
        monitor: NWPathMonitor
    ) {
        self.monitor = monitor
        monitor.start(queue: queue)
        Log.network.debug("Network monitor started")
    }

    public var isConnected: Bool {
        let status = monitor.currentPath.status
        Log.network.debug("Monitor network status: \(status)")
        return status == .satisfied
    }

    public var streamConnection: AsyncStream<NetworkStatus> {
        AsyncStream { continuation in
            monitor.pathUpdateHandler = { path in
                let networkStatus: NetworkStatus = switch path.status {
                case .satisfied: .connected
                case .requiresConnection: .requiresConnection
                case .unsatisfied: .notConnected
                @unknown default: .notConnected
                }
                Log.network.debug("Stream network monitor yields with status: \(networkStatus)")
                continuation.yield(networkStatus)
            }

            continuation.onTermination = { @Sendable _ in
                Log.network.debug("Network monitor stopped")
                monitor.cancel()
            }
        }
    }
}
