//
//  FacebookSignInError.swift
//  Vexta
//
//  Created by MaxAdmin on 06.07.2026.
//

import Foundation

enum FacebookSignInError: Error, Equatable {
    case cannotFindTopViewController
    case invalidCurrentNonce
    case missingLoginConfiguration
    case invalidAuthToken
    case userCancelled
}
