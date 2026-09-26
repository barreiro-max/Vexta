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

        guard !value
            .stringValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        else { return nil }

        do {
            let decoded = try value.decoded(asType: T?.self)
            Log.remoteConfig.debug("RemoteConfigValue: \(decoded), key: \(stringKey), resolved from: \(value.source)")
            return decoded
        } catch {
            Log.remoteConfig.error("Failed to decode key [\(stringKey)] into \(T.self), error: \(error.localizedDescription)")
            return nil
        }
    }

    public subscript<T: Decodable>(key: RemoteConfigKey) -> T? {
        configValue(forKey: key)
    }
}
