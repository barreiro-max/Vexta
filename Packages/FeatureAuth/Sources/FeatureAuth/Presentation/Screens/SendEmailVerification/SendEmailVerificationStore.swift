//
//  SendEmailVerificationStore.swift
//  Vexta
//
//  Created by MaxAdmin on 27.07.2026.
//

import Foundation
import Domain

@MainActor
@Observable
final class SendEmailVerificationStore {

    // MARK: - Nested Types
    enum State: Equatable {
        case idle
        case loading(for: Operation)
        case failure(for: Operation, error: AuthError)
        case completed(for: Operation)

        var isLoading: Bool {
            if case .loading = self { true } else { false }
        }
    }

    enum Operation {
        case sendEmailVerification
        case checkEmailVerification
        case observeTimer
    }

    enum Intent {
        case sendEmailVerification
        case checkEmailVerification
    }

    enum Event {
        case emailVerified
        case failed(error: AuthError)
    }

    // MARK: - State
    private(set) var state: State = .idle

    // MARK: - Timer
    private let cooldownTimerUseCase: CooldownTimerUseCase
    private(set) var isCooldownActive: Bool = false
    private(set) var cooldownSeconds: Int = 0

    // MARK: - UseCase
    private let sendEmailVerificationUseCase: SendEmailVerificationUseCase
    private let completeEmailVerificationUseCase: CompleteEmailVerificationUseCase

    // MARK: - Event
    private let onStoreEvent: (Event) -> Void

    @ObservationIgnored
    private var sendEmailVerificationTask: Task<Void, Never>?

    @ObservationIgnored
    private var checkEmailVerificationTask: Task<Void, Never>?

    // MARK: - Init
    init(
        cooldownTimerUseCase: CooldownTimerUseCase,
        sendEmailVerificationUseCase: SendEmailVerificationUseCase,
        completeEmailVerificationUseCase: CompleteEmailVerificationUseCase,
        onStoreEvent: @escaping (Event) -> Void
    ) {
        self.cooldownTimerUseCase = cooldownTimerUseCase
        self.sendEmailVerificationUseCase = sendEmailVerificationUseCase
        self.completeEmailVerificationUseCase = completeEmailVerificationUseCase
        self.onStoreEvent = onStoreEvent
    }

    // MARK: - Intent Handler
    func send(_ intent: Intent) {
        switch intent {
        case .sendEmailVerification:
            sendEmailVerificationTask?.cancel()
            sendEmailVerificationTask = Task {
                await sendEmailVerification()
            }
        case .checkEmailVerification:
            checkEmailVerificationTask?.cancel()
            checkEmailVerificationTask = Task { await checkEmailVerification() }

        }
    }

    // MARK: - Private Actions
    private func sendEmailVerification() async {

        guard !state.isLoading else { return }
        state = .loading(for: .sendEmailVerification)

        do throws(AuthError) {
            try await sendEmailVerificationUseCase.execute()
            if Task.isCancelled { return }
            state = .completed(for: .sendEmailVerification)

            await observeTimer(duration: 60)
        } catch {
            if Task.isCancelled { return }
            handleError(for: .sendEmailVerification, error: error)
        }
    }

    // TODO: — upgrade timer logic from local to foreground (with User Defaults)
    private func observeTimer(duration: Int) async {
        precondition(duration > 0)
        isCooldownActive = true
        state = .loading(for: .observeTimer)

        defer {
            isCooldownActive = false
            cooldownSeconds = 0
            state = .completed(for: .observeTimer)
        }

        for await second in cooldownTimerUseCase.execute(from: duration) {
            if Task.isCancelled {
                state = .failure(for: .observeTimer, error: .userCancelled)
                break
            }
            cooldownSeconds = second
        }
    }

    private func checkEmailVerification() async {
        state = .loading(for: .checkEmailVerification)

        do throws(AuthError) {
            let isVerified = try await completeEmailVerificationUseCase.execute()
            if Task.isCancelled { return }

            if isVerified {
                state = .completed(for: .checkEmailVerification)
                onStoreEvent(.emailVerified)
            } else {
                handleError(for: .checkEmailVerification, error: .emailNotVerified)
            }

        } catch {
            if Task.isCancelled { return }
            handleError(for: .checkEmailVerification, error: error)
        }
    }

    private func handleError(for operation: Operation, error: AuthError) {
        state = .failure(for: operation, error: error)
        onStoreEvent(.failed(error: error))
    }
}
