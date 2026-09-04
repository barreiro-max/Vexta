//
//  ReminderType.swift
//  Vexta
//
//  Created by MaxAdmin on 31.08.2026.
//

import Foundation

public enum ReminderType: Equatable, Hashable, Sendable {
    case afterSeconds(TimeInterval)
    case afterDays(Int, hour: Int, minute: Int)
    case daily(hour: Int, minute: Int)
}
