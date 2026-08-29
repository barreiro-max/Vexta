//
//  PreviewRegisterUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation
import Domain

struct PreviewRegisterUseCase: RegisterUseCase {
    func execute(email: String, password: String) async throws(AuthError) -> String {
        return "preview_registerUseCase_UID"
    }
}
