//
//  ReminderDeliveryStatus.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation

public enum ReminderDeliveryStatus: Sendable {
    case pending(with: [ReminderContent.ID])
    case delivered(with: [ReminderContent.ID])
    case allPending
    case allDelivered
    case all
}
