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

    public func fetchMaintenanceMessage() async -> String? {
        isPreviewMaintenance ? "Preview maintenance message" : nil
    }

    public func fetchForceUpdateURL() async -> URL? {
        isPreviewForceUpdate ? URL(string: "https://preview.url.com") : nil
    }
}
