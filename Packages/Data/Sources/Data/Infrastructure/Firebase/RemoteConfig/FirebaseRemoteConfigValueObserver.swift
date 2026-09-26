//
//  FirebaseRemoteConfigValueObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 17.09.2026.
//

import Foundation
import Domain
import Telemetry
import FirebaseRemoteConfig

public struct FirebaseRemoteConfigValueObserver {
    public init() {}
    private var remoteConfig: RemoteConfig { .remoteConfig() }
}

extension FirebaseRemoteConfigValueObserver: RemoteConfigValueObserver {

    public var stream: AsyncStream<Domain.RemoteConfigValue> {
        AsyncStream { continuation in
            let task = Task {
                Log.remoteConfig.debug("Stream remote config value started")
                await observeRemoteConfigValue(with: continuation)
                continuation.finish()
                Log.remoteConfig.debug("Stream remote config value finished")
            }
            continuation.onTermination = { _ in
                task.cancel()
                Log.remoteConfig.debug("Stream remote config value stopped")
            }
        }
    }

    private func observeRemoteConfigValue(
        with continuation: AsyncStream<Domain.RemoteConfigValue>.Continuation
    ) async {
        do {
            for try await configUpdate in remoteConfig.configUpdates {
                if Task.isCancelled { break }
                try await remoteConfig.activate()

                let keys = configUpdate.updatedKeys
                Log.remoteConfig.debug("Updated keys from stream: \(keys)")

                for key in keys {
                    let rawValue = remoteConfig.configValue(forKey: key)
                    let value = RemoteConfigValue(key: key, firValue: rawValue)
                    Log.remoteConfig.debug("Stream remote config value: \(value)")
                    continuation.yield(value)
                }
            }
        } catch {
            Log.remoteConfig.error("Remote config stream error: \(error.localizedDescription)")
            continuation.finish()
        }
    }
}
