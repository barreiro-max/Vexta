//
//  AppConfigurator.swift
//  Vexta
//
//  Created by MaxAdmin on 02.07.2026.
//

import Foundation

// MARK: - Shared imports
import Environment
import Telemetry

// MARK: - SDK imports
import RevenueCat

public protocol RevenueCatConfigurable: Sendable {
    func configure() async
}

public struct RevenueCatConfiguration: RevenueCatConfigurable {

    public init() {}
    
    public func configure() async {
        Purchases.logLevel = .debug

        Purchases.configure(
            withAPIKey: InfoPlistConfiguration.revenueCatAPIKey
        )

        Log.purchase.debug("💰 RevenueCat in sandbox: \(Purchases.shared.isSandbox)")

        if Purchases.isConfigured {
            Log.purchase.notice("💰 RevenueCat configured")
        } else {
            Log.purchase.fault("⛔️ Failed to configure RevenueCat")
        }
    }
}
