//
//  MainFlowCoordinatorIntent.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation

enum MainFlowCoordinatorIntent {
    case finishedFlow
    case showAlert(error: MainError)
}
