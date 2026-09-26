//
//  PreviewFetchRemoteConfigUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 10.08.2026.
//

import Foundation

public struct PreviewFetchRemoteConfigUseCase: FetchRemoteConfigUseCase {

    private let isPreviewMaintenance: Bool
    private let isPreviewForceUpdate: Bool

    public init(isPreviewMaintenance: Bool, isPreviewForceUpdate: Bool) {
        self.isPreviewMaintenance = isPreviewMaintenance
        self.isPreviewForceUpdate = isPreviewForceUpdate
    }

    public var isMaintenance: Bool {
        isPreviewMaintenance
    }

    public var isForceUpdate: Bool {
        isPreviewForceUpdate
    }
}
