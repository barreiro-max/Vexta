//
//  MainFlowCoordinatorEvent.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation

public enum MainFlowCoordinatorEvent {
    case finished
    case alerted(error: MainError)
}
