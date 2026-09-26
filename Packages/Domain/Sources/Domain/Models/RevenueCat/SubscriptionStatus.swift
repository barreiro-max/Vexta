//
//  SubscriptionStatus.swift
//  Vexta
//
//  Created by MaxAdmin on 17.09.2026.
//

import Foundation

public enum SubscriptionStatus: Sendable, Hashable, Codable {
    case active
    case inactive

    public var isPremium: Bool { self == .active }
}
