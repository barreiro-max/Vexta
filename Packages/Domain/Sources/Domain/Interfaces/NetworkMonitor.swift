//
//  NetworkMonitor.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol NetworkMonitor: Sendable {
    var isConnected: Bool { get }
    var streamConnection: AsyncStream<NetworkStatus> { get }
}
