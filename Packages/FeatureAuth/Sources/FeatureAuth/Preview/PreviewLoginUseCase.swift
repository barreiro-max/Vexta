//
//  PreviewLoginUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 21.08.2026.
//

import Foundation
import Domain

struct PreviewLoginUseCase: LoginUseCase {
    func execute(with provider: AuthProviderOption) async throws(AuthError) -> String {
        return "preview_loginUseCase_UID"
    }
}
