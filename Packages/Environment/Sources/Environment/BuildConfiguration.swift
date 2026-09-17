//
//  XcodeConfiguration.swift
//  Vexta
//
//  Created by MaxAdmin on 17.09.2026.
//

import Foundation

public enum BuildConfiguration {

    // MARK: - Environment
    public static var environment: AppEnvironment { .current }

    // MARK: - Environment Variables
    public static var isUserPremium: Bool { EnvironmentVariables.isUserPremium }
    public static var isTestConfiguration: Bool { EnvironmentVariables.isTestConfiguration }
    public static var isUseFirebaseEmulator: Bool { EnvironmentVariables.isUseFirebaseEmulator }
    public static var isUseDebugView: Bool { EnvironmentVariables.isUseDebugView }

    // MARK: - InfoPlistConfiguration
    public static var fakeStoreAPIURL: URL { InfoPlistConfiguration.fakeStoreAPIURL }
    public static var revenueCatAPIKey: String { InfoPlistConfiguration.revenueCatAPIKey }
    public static var isAnalyticsCollectionEnabled: Bool { InfoPlistConfiguration.isAnalyticsCollectionEnabled }

    // MARK: - Launch Arguments
    public static var isFirebaseDebugEnabled: Bool { LaunchArguments.firebaseDebugEnabled }
    public static var isFirebaseDebugDisabled: Bool { LaunchArguments.firebaseDebugDisabled }
    public static var isFirebaseAnalyticsEnabled: Bool { LaunchArguments.firebaseAnalyticsEnabled }
    public static var isFirebaseAnalyticsDisabled: Bool { LaunchArguments.firebaseAnalyticsDisabled }
}
