//
//  PreviewSendPasswordResetUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation
import Domain

struct PreviewSendPasswordResetUseCase: SendPasswordResetUseCase {
    func execute(email: String) async throws(AuthError) {}
}
