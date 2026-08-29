//
//  EnvironmentVariables.swift
//  Vexta
//
//  Created by MaxAdmin on 19.07.2026.
//

import Foundation

public enum EnvironmentVariables {
    static var isUserPremium:       Bool { EnvironmentKey.isPremium.isActive }
    static var isTestConfiguration: Bool { EnvironmentKey.isTesting }
}

fileprivate enum EnvironmentKey {
    case isPremium

    private var key: String {
        switch self {
        case .isPremium: "FORCE_PREMIUM"
        }
    }

    private var expectedValue: String? {
        switch self {
        case .isPremium: "YES"
        }
    }

    static var isTesting: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    var isActive: Bool {
        ProcessInfo.processInfo.environment[key] == expectedValue
    }

    var isInactive: Bool { !isActive }
}
