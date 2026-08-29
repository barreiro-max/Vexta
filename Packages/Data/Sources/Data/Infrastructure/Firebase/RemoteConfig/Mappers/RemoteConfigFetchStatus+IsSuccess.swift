//
//  RemoteConfigFetchStatus+IsSuccess.swift
//  Vexta
//
//  Created by MaxAdmin on 09.07.2026.
//

import FirebaseRemoteConfig

extension RemoteConfigFetchStatus {
    var isSuccess: Bool {
        switch self {
        case .success:                           true
        case .throttled, .noFetchYet, .failure:  false
        @unknown default:                        false
        }
    }
}
