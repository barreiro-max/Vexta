//
//  NWPathNetworkStatusObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Network
import Domain
import Telemetry

public struct NWPathNetworkStatusObserver: NetworkStatusObserver {
    private let monitor: NWPathMonitor

    public init(
        monitor: NWPathMonitor
    ) {
        self.monitor = monitor
    }

    public var isConnected: Bool {
        let status = monitor.currentPath.status
        Log.network.debug("Network status observer status: \(status)")
        return status == .satisfied
    }

    public var stream: AsyncStream<NetworkStatus> {
        AsyncStream { continuation in
            Log.network.debug("Network status observer started")
            monitor.start(queue: .global(qos: .background))

            let task = Task {
                Log.network.debug("Stream network observer started")
                await observeNetworkStatus(with: continuation)
                continuation.finish()
                Log.network.debug("Stream network observer finished")
            }

            continuation.onTermination = { @Sendable _ in
                task.cancel()
                monitor.cancel()
                Log.network.debug("Stream network observer terminated")
            }
        }
    }

    private func observeNetworkStatus(
        with continuation: AsyncStream<NetworkStatus>.Continuation
    ) async {
        var previous: NetworkStatus?

        for await path in monitor {
            if Task.isCancelled { break }

            let networkStatus: NetworkStatus = switch path.status {
            case .satisfied:          .connected
            case .requiresConnection: .requiresConnection
            case .unsatisfied:        .notConnected
            @unknown default:         .notConnected
            }

            guard networkStatus != previous else {
                Log.network.debug("Current network status is equal previous")
                continue
            }
            previous = networkStatus

            Log.network.debug("Stream network observer yields with status: \(networkStatus)")
            continuation.yield(networkStatus)
        }
    }
}
