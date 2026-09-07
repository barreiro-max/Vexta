//
//  NetworkStatus.swift
//  Vexta
//
//  Created by MaxAdmin on 08.08.2026.
//

import Foundation

public enum NetworkStatus: Sendable, Equatable {
    case connected
    case notConnected
    case requiresConnection
}
