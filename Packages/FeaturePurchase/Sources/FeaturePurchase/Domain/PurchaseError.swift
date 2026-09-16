//
//  PurchaseError.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//

import Foundation

public enum PurchaseError: Error, LocalizedError, Equatable {
    case customerInfoNotFound

    public var errorDescription: String? {
        switch self {
        case .customerInfoNotFound:
            String(localized: "Customer info not found")
        }
    }
}
