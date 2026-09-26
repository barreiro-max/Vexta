//
//  DebugTab.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//
#if DEBUG
import Foundation

enum DebugTab: String, CaseIterable, Identifiable {
    case actions = "Actions"
    case system = "System"
    case environment = "Environment"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .actions: "play.circle"
        case .system: "cpu"
        case .environment: "gearshape.2"
        }
    }
}
#endif
