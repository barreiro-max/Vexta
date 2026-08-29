//
//  TabFlowCoordinatorEvent.swift
//  Vexta
//
//  Created by MaxAdmin on 25.08.2026.
//

import Foundation

import FeatureMain

enum TabFlowCoordinatorEvent {
    case finishedMain
    case alertedMain(with: MainError)
}
