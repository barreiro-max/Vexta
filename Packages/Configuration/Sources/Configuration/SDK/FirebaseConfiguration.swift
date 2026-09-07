//
//  FirebaseAppConfiguration.swift
//  Vexta
//
//  Created by MaxAdmin on 11.07.2026.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseRemoteConfig
import Telemetry
import Environment

public protocol FirebaseConfigurable: Sendable {
    func configureFirebaseApp()
    func configureFirebaseFeatures() async
}

public struct FirebaseConfiguration: FirebaseConfigurable {

    public init() {}

    private let resource: String = "GoogleService-Info"

    public func configureFirebaseApp() {
        guard
            let path = Bundle.main.path(
                forResource: resource,
                ofType: "plist"
            ),
            let options = FirebaseOptions(contentsOfFile: path) else {
            Log.system.fault("⛔️ Not found Firebase config file: \(resource)")
            return
        }

        FirebaseApp.configure(options: options)

        Log.system.notice("🔥 Firebase configured with: \(resource).plist")
    }

    public func configureFirebaseFeatures() async {
        async let configuredRemoteConfig: Void = configureRemoteConfig()
        async let configuredAuthEmulator: Void = configureAuthEmulator()

        _ = await (
            configuredRemoteConfig,
            configuredAuthEmulator
        )
        Log.system.notice("🔥 Firebase Features configured")
    }

#if DEBUG
    private func configureAuthEmulator() async {
        if EnvironmentVariables.isUseFirebaseEmulator {
            Auth.auth().useEmulator(withHost: "localhost", port: 9099)
            Log.auth.notice("🔥 Firebase Auth Emulator configured")
        } else {
            Log.auth.notice("🔥 Firebase Auth Emulator is not used")
        }
    }
#endif

    private func configureRemoteConfig() async {
        let settings = RemoteConfigSettings()
        let contentsOfFile = "RemoteConfigDefaults-Dev"
#if DEBUG
        settings.minimumFetchInterval = 0
#endif
        let rc = RemoteConfig.remoteConfig()
        rc.setDefaults(fromPlist: contentsOfFile)
        rc.configSettings = settings

        do {
            try await rc.fetchAndActivate()
            Log.remoteConfig.info("🔥 Firebase RemoteConfig completed fetchAndActivate")
        } catch {
            Log.remoteConfig.error("🔥 Firebase RemoteConfig failed fetchAndActivate")
        }

        Log.remoteConfig.notice("🔥 Firebase RemoteConfig configured with plist: \(contentsOfFile).plist\n minimumFetchInterval: [\(settings.minimumFetchInterval, format: .fixed(precision: 0))]s")
    }
}

