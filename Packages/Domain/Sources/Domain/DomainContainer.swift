//
//  DomainContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import Foundation

public final class DomainContainer {
    private let remoteConfigRepository: RemoteConfigRepository

    public init(remoteConfigRepository: RemoteConfigRepository) {
        self.remoteConfigRepository = remoteConfigRepository
    }

    public lazy var fetchRemoteConfigUseCase =  FetchRemoteConfigUseCaseImpl(remoteConfigRepository: remoteConfigRepository)
}
