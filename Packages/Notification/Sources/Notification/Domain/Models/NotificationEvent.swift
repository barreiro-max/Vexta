//
//  NotificationEvent.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation

// TODO: — change non-sendable `[AnyHashable: Any]` to model which conform Sendable
public enum NotificationEvent: Sendable {
    case willPresent(userInfo: [String: Sendable])
    case didReceive(actionIdentifier: String, userInfo: [String: Sendable])
}
