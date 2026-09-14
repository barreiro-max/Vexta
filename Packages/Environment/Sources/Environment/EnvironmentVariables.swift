//
//  EnvironmentVariables.swift
//  Vexta
//
//  Created by MaxAdmin on 19.07.2026.
//

import Foundation

public enum EnvironmentVariables {
    public static var isUserPremium:       Bool { EnvironmentKey.isPremium.isActive }
    public static var isTestConfiguration: Bool { EnvironmentKey.isTesting }
    public static var isUseFirebaseEmulator: Bool { EnvironmentKey.isFirebaseEmulator.isActive }
    public static var isUseDebugView: Bool { EnvironmentKey.isDebugView.isActive }
}

fileprivate enum EnvironmentKey {
    case isPremium
    case isFirebaseEmulator
    case isDebugView

    private var key: String {
        switch self {
        case .isPremium: "FORCE_PREMIUM"
        case .isFirebaseEmulator: "FIREBASE_EMULATOR"
        case .isDebugView: "DEBUG_VIEW"
        }
    }

    private var expectedValue: String? {
        switch self {
        case .isPremium: "YES"
        case .isFirebaseEmulator: "YES"
        case .isDebugView: "YES"
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
