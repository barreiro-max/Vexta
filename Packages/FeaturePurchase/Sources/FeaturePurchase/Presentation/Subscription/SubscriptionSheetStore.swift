//
//  SubscriptionSheetStore.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//

import Foundation

@MainActor
@Observable
public final class SubscriptionSheetStore {

    // MARK: - Nested Types
    enum State: Equatable {
        case idle
        case loading
        case hasPremium
        case neededPaywall
        case failure(error: PurchaseError)

        var isLoading: Bool {
            if case .loading = self { true } else { false }
        }
    }

    enum Intent {
        case checkUserPremiumStatus
    }

    public enum SheetEvent {
        case checkUserPremiumSucceeded
        case checkUserPremiumFailed(error: PurchaseError)
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - Dependencies
    private let checkUserPremiumStatusUseCase: CheckUserPremiumStatusUseCase
    private let onStoreSheetEvent: (SheetEvent) -> Void

    @ObservationIgnored
    private var checkUserPremiumTask: Task<Void, Never>?

    // MARK: - Init
    public init(
        checkUserPremiumStatusUseCase: CheckUserPremiumStatusUseCase,
        onStoreSheetEvent: @escaping (SheetEvent) -> Void
    ) {
        self.checkUserPremiumStatusUseCase = checkUserPremiumStatusUseCase
        self.onStoreSheetEvent = onStoreSheetEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .checkUserPremiumStatus:
            checkUserPremiumTask?.cancel()
            checkUserPremiumTask = Task { await checkUserPremium() }
        }
    }

    // MARK: - Private Actions
    private func checkUserPremium() async {
        guard !state.isLoading else { return }
        state = .idle
        state = .loading

        do throws(PurchaseError) {
            let hasPremium = try await checkUserPremiumStatusUseCase.execute()

            if Task.isCancelled {
                state = .idle
                return
            }

            state = hasPremium ? .hasPremium : .neededPaywall
            onStoreSheetEvent(.checkUserPremiumSucceeded)
        } catch {
            if Task.isCancelled {
                state = .idle
                return
            }
            state = .failure(error: error)
            onStoreSheetEvent(.checkUserPremiumFailed(error: error))
        }
    }
}
