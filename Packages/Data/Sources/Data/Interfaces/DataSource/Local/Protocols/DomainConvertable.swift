//
//  DomainConvertable.swift
//  Vexta
//
//  Created by MaxAdmin on 05.08.2026.
//

import Foundation

protocol DomainConvertable {

    associatedtype DomainValue: Hashable, Equatable, Sendable

    var toDomain: DomainValue { get }
}
