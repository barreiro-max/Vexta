//
//  SplashStoreState.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation

enum SplashStoreState {
    case idle
    case loading(message: String? = nil)
    case failure(error: SplashError)
    case completed

    var isLoading: Bool {
        if case .loading = self { true } else { false }
    }
}
