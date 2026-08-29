//
//  RevenueCatProvider.swift
//  Vexta
//
//  Created by MaxAdmin on 13.07.2026.
//

import Foundation
import RevenueCat

struct RevenueCatProvider {

    private var revenueCat: Purchases {
        Purchases.shared
    }
}

extension RevenueCatProvider: PurchaseProvider {
    var hasPremium: Bool {
        get async throws {
            let customerInfo = try await revenueCat.customerInfo()
            let key = "Vexta Premium"
            return customerInfo.entitlements[key]?.isActive == true
        }
    }
}
