//
//  RemoteConfigValueObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 26.09.2026.
//

import Foundation

public protocol RemoteConfigValueObserver: Sendable {
    var stream: AsyncStream<RemoteConfigValue> { get }
}
