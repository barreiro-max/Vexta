//
//  NetworkStatusObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol NetworkStatusObserver: Sendable {
    var isConnected: Bool { get }
    @MainActor var stream: AsyncStream<NetworkStatus> { get }
}
