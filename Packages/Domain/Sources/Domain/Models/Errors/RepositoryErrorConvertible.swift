//
//  RepositoryErrorConvertible.swift
//  Vexta
//
//  Created by MaxAdmin on 08.08.2026.
//

import Foundation

public protocol RepositoryErrorConvertible: Error {
    var asRepositoryError: RepositoryError { get }
}
