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
    enum State {
        case idle
        case loading
        case failure(error: AuthError)
        case verificationSent
        case verified
    }

    enum Intent {
        case sendEmailVerification(with: String)
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
        case .sendEmailVerification(let email):
            sendEmailVerificationTask?.cancel()
            sendEmailVerificationTask = Task {
                await sendEmailVerification(email: email)
            }
        case .checkEmailVerification:
            checkEmailVerificationTask?.cancel()
            checkEmailVerificationTask = Task { await checkEmailVerification() }

        }
    }

    // MARK: - Private Actions
    private func sendEmailVerification(email: String) async {
        state = .loading

        do throws(AuthError) {
            try await sendEmailVerificationUseCase.execute(email: email)
            if Task.isCancelled { return }
            state = .verificationSent

            await observeTimer(duration: 60)
        } catch {
            if Task.isCancelled { return }
            handleError(error)
        }
    }

    // TODO: — upgrade timer logic from local to foreground (with User Defaults)
    private func observeTimer(duration: Int) async {
        precondition(duration > 0)
        isCooldownActive = true
        defer {
            isCooldownActive = false
            cooldownSeconds = 0
        }
        
        for await second in cooldownTimerUseCase.execute(from: duration) {
            if Task.isCancelled { break }
            cooldownSeconds = second
        }
    }

    private func checkEmailVerification() async {
        state = .loading

        do throws(AuthError) {
            let isVerified = try await completeEmailVerificationUseCase.execute()
            if Task.isCancelled { return }

            if isVerified {
                state = .verified
                onStoreEvent(.emailVerified)
            } else {
                handleError(.emailNotVerified)
            }

        } catch {
            if Task.isCancelled { return }
            handleError(error)
        }
    }

    private func handleError(_ error: AuthError) {
        state = .failure(error: error)
        onStoreEvent(.failed(error: error))
    }
}
