//
//  AppEnvironment.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import Foundation

public enum AppEnvironment: String {
    case prod  = "PROD"
    case stage = "STAGE"
    case dev   = "DEV"
    case test  = "TEST"

    public var configTitle: String { self.rawValue }

    public static var current: AppEnvironment {
#if DEBUG
        if EnvironmentVariables.isTestConfiguration {
            return .test
        }
        return .dev
#else
        let raw = InfoPlistConfiguration.currentAppEnvironment

        if let env = AppEnvironment(rawValue: raw) {
            return env
        }
        return .prod
#endif
    }
}
