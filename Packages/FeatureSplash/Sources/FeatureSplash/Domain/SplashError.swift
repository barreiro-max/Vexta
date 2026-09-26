//
//  SplashError.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation

public enum SplashError: Error, LocalizedError, Equatable {
    case noInternetConnection
    case maintenanceMode
    case forceUpdateRequired
    case unknown(underlying: NSError)

    public var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            String(localized: "No internet connection.")
        case .maintenanceMode:
            String(localized: "App is under maintenance")
        case .forceUpdateRequired:
            String(localized: "Update the app to the latest version.")
        case .unknown(let underlying):
            underlying.localizedDescription
        }
    }
}

extension SplashError: CustomNSError {
    public static var errorDomain: String {
        String(describing: Self.self)
    }

    public var errorCode: Int {
        switch self {
        case .noInternetConnection: 401
        case .maintenanceMode:      503
        case .forceUpdateRequired:  426
        case .unknown(let underlying): underlying.code
        }
    }
}
