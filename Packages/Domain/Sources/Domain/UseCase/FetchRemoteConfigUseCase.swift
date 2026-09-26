//
//  FetchRemoteConfigUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 05.08.2026.
//

import Foundation

public protocol FetchRemoteConfigUseCase: Sendable {
    var isForceUpdate: Bool { get }
}

public struct FetchRemoteConfigUseCaseImpl {

    private let remoteConfigRepository: RemoteConfigRepository

    public init(remoteConfigRepository: RemoteConfigRepository) {
        self.remoteConfigRepository = remoteConfigRepository
    }
}

extension FetchRemoteConfigUseCaseImpl: FetchRemoteConfigUseCase {

    public var isForceUpdate: Bool {
        boolValue(for: .isForceUpdate)
    }

    private func boolValue(for key: RemoteConfigKey) -> Bool {
        if let value: Bool = remoteConfigRepository[key] {
            return value
        }
        return false
    }
}
