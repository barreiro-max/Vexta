//
//  FirebaseRemoteConfigRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 03.07.2026.
//

import Foundation
import FirebaseRemoteConfig
import Telemetry
import Domain

public final class FirebaseRemoteConfigRepository {
    public init() {}

    private var rc: RemoteConfig {
        RemoteConfig.remoteConfig()
    }
}

extension FirebaseRemoteConfigRepository: RemoteConfigRepository {

    public func observeConfigUpdates() async {
        for await _ in configUpdates {
            do {
                let activated = try await rc.activate()
                Log.remoteConfig.notice("Real-time changes activated: \(activated)")
            } catch {
                Log.remoteConfig.error("Failed to activate real-time update: \(error.localizedDescription)")
            }
        }
    }

    // implement this instead of using the SDK's because the SDK stops the stream when the listener returns (nil, nil) or errors because want to keep the stream alive in this case
    public var configUpdates: AsyncStream<Set<String>> {
        AsyncStream { continuation in
            let listener = rc.addOnConfigUpdateListener { update, error in
                if let error {
                    Log.remoteConfig.error("Real-time update error: \(error.localizedDescription)")
                    continuation.finish()
                    return
                }
                guard let keys = update?.updatedKeys else { return }
                Log.remoteConfig.debug("Real-time update detected. Changed keys: \(keys)")
                continuation.yield(keys)
            }
            continuation.onTermination = { @Sendable _ in
                listener.remove()
            }
        }
    }

    public func fetchAndActivate() async -> Bool {
        do {
            let status = try await rc.fetchAndActivate()
            Log.remoteConfig.error("Remote config fetch and activate status: \(status)")
            return status.isSuccess
        } catch {
            Log.remoteConfig.error("fetchAndActivate crashed with error: \(error.localizedDescription)")
            return false
        }
    }

    public func activate() async throws -> Bool {
        do {
            let activated = try await rc.activate()
            Log.remoteConfig.notice("Remote config is activated: \(activated)")
            return activated
        } catch {
            Log.remoteConfig.error("Failed to explicitly activate configurations: \(error.localizedDescription)")
            throw error
        }
    }

    public func fetch() async throws -> Bool {
        do {
            let status = try await rc.fetch()
            Log.remoteConfig.debug("Remote config fetch status: \(status)")
            return status.isSuccess
        } catch {
            Log.remoteConfig.error("Fetch operation failed with error: \(error.localizedDescription)")
            throw error
        }
    }

    public func configValue<T: Decodable>(forKey key: RemoteConfigKey) -> T? {
        let stringKey = key.toString
        let value = rc.configValue(forKey: stringKey)
        Log.remoteConfig.debug("Key [\(stringKey)] resolved from: \(value.source)")

        guard !value
            .stringValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        else { return nil }

        do {
            return try value.decoded(asType: T?.self)
        } catch {
            Log.remoteConfig.error("Failed to decode key [\(stringKey)] into \(T.self), error: \(error.localizedDescription)")
            return nil
        }
    }

    public subscript<T: Decodable>(key: RemoteConfigKey) -> T? {
        configValue(forKey: key)
    }
}
