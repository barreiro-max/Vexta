//
//  PreviewLinkAccountUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 07.09.2026.
//

import Foundation
import Domain

struct PreviewLinkAccountUseCase: LinkAccountUseCase {
    func execute(with provider: LinkableAuthProviderOption) async throws(AccountError) -> String {
        "Test_link_user_UID"
    }
}
