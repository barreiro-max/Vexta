//
//  GetUserUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 21.07.2026.
//

import Foundation

public protocol GetUserUseCase {
    func execute(id: User.ID) async throws -> User
}

public struct GetUserUseCaseImpl: GetUserUseCase {

    private let userRepository: UserRepository
    private let analyticsTracker: AnalyticsTracker
    private let crashlyticsRecorder: CrashlyticsRecorder

    public init(
        userRepository: UserRepository,
        analyticsTracker: AnalyticsTracker,
        crashlyticsRecorder: CrashlyticsRecorder,
    ) {
        self.userRepository = userRepository
        self.analyticsTracker = analyticsTracker
        self.crashlyticsRecorder = crashlyticsRecorder
    }

    public func execute(id: User.ID) async throws(RepositoryError) -> User {
        do throws(RepositoryError) {
            let user = try await userRepository.fetch(userId: id)
            analyticsTracker.track(event: .addUser(value: user.email))

            return user
        } catch {
            let reportableError = error.asReportable
            crashlyticsRecorder.record(
                error: reportableError,
                crashRecordInfo: .init(userInfo: reportableError.userInfo)
            )
            throw error
        }
    }
}
