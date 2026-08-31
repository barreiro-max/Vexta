//
//  PreviewUserAnonymousUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 24.08.2026.
//

import Foundation
import Domain

struct PreviewUserAnonymousUseCase: UserAnonymousUseCase {
    func execute() async throws(AccountError) -> Bool { false }
}
