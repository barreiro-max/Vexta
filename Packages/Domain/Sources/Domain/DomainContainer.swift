//
//  DomainContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 26.07.2026.
//

import Foundation

public final class DomainContainer {
    private let onboardingRepository: OnboardingRepository
    private let remoteConfigRepository: RemoteConfigRepository

    public init(
        onboardingRepository: OnboardingRepository,
        remoteConfigRepository: RemoteConfigRepository
    ) {
        self.onboardingRepository = onboardingRepository
        self.remoteConfigRepository = remoteConfigRepository
    }

    public lazy var checkOnboardingPassedUseCase = CheckOnboardingPassedUseCaseImpl(
        onboardingRepository: onboardingRepository
    )

    public lazy var completeOnboardingUseCase = CompleteOnboardingUseCaseImpl(
        onboardingRepository: onboardingRepository
    )

    public lazy var fetchRemoteConfigUseCase =  FetchRemoteConfigUseCaseImpl(remoteConfigRepository: remoteConfigRepository)

    public lazy var cooldownTimerUseCase = CooldownTimerUseCaseImpl()
}
