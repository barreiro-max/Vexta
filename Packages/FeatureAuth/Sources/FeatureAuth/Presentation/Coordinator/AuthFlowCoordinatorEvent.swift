//
//  AuthFlowCoordinatorEvent.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation
import Domain

public enum AuthFlowCoordinatorEvent {
    case finished
    case alerted(error: AuthError)
}
