//
//  RemoteConfigFetchAndActivateStatus+IsSuccess.swift
//  Vexta
//
//  Created by MaxAdmin on 09.07.2026.
//

import FirebaseRemoteConfig

extension RemoteConfigFetchAndActivateStatus {
    var isSuccess: Bool {
        switch self {
        case .successUsingPreFetchedData: true
        case .successFetchedFromRemote:   true
        case .error:                      false
        @unknown default:                 false
        }
    }
}
