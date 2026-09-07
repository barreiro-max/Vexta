//
//  AppleSignInError.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation

enum AppleSignInError: Error, Equatable {
    case cannotFindTopViewController
    case invalidAppleIdCredential
}
