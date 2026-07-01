//
//  TTLValidatable.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation
import SwiftData

protocol TTLValidatable: PersistentModel {
    var id: Int { get }
    var createdAt: Date { get }
}
