//
//  GoogleSignInError.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation

enum GoogleSignInError: Error {
    case invalidRestorePreviousSignIn
    case cannotFindTopViewController
    case invalidSignIn
    case invalidIdToken
}
