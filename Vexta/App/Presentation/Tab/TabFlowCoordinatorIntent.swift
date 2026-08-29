//
//  TabFlowCoordinatorIntent.swift
//  Vexta
//
//  Created by MaxAdmin on 25.08.2026.
//

import Foundation

import FeatureMain

enum TabFlowCoordinatorIntent {
    case finishedMain
    case showMainAlert(with: MainError)
}
