//
//  FacebookSignInError.swift
//  Vexta
//
//  Created by MaxAdmin on 06.07.2026.
//

import Foundation

enum FacebookSignInError: Error {
    case cannotFindTopViewController
    case invalaidCurrentNonce
    case missingLoginConfiguration
    case invalidAccessToken
    case userCancelled
}
