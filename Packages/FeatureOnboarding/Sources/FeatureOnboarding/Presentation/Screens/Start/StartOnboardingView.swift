//
//  StartOnboardingView.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import SwiftUI
import Domain

struct StartOnboardingView: View {

    @State private var store: StartOnboardingStore

    init(store: StartOnboardingStore) {
        self.store = store
    }

    var body: some View {
        Button("Start StartOnboarding") {
            store.send(.nextPage)
        }
        Button("Skip all") {
            store.send(.skip)
        }
    }
}

#Preview {
    let completeOnboardingUseCase = PreviewCompleteOnboardingUseCase()
    let store = StartOnboardingStore(completeOnboardingUseCase: completeOnboardingUseCase) {_ in}
    StartOnboardingView(store: store)
}
