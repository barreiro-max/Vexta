//
//  FetchRemoteConfigUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 05.08.2026.
//

import Foundation

public protocol FetchRemoteConfigUseCase: Sendable {
    func fetchMaintenanceMessage() async -> String?
    func fetchForceUpdateURL() async -> URL?
}

public struct FetchRemoteConfigUseCaseImpl {

    private let remoteConfigRepository: RemoteConfigRepository

    public init(remoteConfigRepository: RemoteConfigRepository) {
        self.remoteConfigRepository = remoteConfigRepository
    }
}

extension FetchRemoteConfigUseCaseImpl: FetchRemoteConfigUseCase {

    public func fetchMaintenanceMessage() async -> String? {
        remoteConfigRepository[.maintenanceMessage]
    }
    
    public func fetchForceUpdateURL() async -> URL? {
        remoteConfigRepository[.forceUpdateURL]
    }
}
