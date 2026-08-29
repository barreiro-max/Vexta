//
//  AuthFlowCoordinatorIntent.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation
import Domain

enum AuthFlowCoordinatorIntent {
    case pushed(route: AuthRoute)
    case popped
    case poppedToRoot
    
    case finishedFlow
    case showAlert(with: AuthError)
}
