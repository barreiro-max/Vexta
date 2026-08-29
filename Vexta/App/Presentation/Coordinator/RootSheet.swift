//
//  RootSheet.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import Foundation

enum RootSheet: Hashable, Sendable {
    case subscription
}

extension RootSheet: Identifiable {
    var id: String { "\(self)" }
}
