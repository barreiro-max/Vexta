//
//  PurchaseProvider.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol PurchaseProvider: Sendable {
    var hasPremium: Bool { get async throws }
}
