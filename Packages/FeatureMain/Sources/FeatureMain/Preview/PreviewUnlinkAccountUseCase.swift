//
//  PreviewUnlinkAccountUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 07.09.2026.
//

import Foundation
import Domain

struct PreviewUnlinkAccountUseCase: UnlinkAccountUseCase {
    func execute(from provider: LinkableAuthProviderOption) async throws(AccountError) -> String {
        "Test_unlink_user_UID"
    }
}
