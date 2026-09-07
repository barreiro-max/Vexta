//
//  RootContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 14.06.2026.
//

import Foundation

// MARK: - Shared imports
import Configuration
import Environment
import Domain
import Data
import Presentation
import Telemetry
import Notification

// MARK: - Feature imports
import FeatureSplash
import FeatureOnboarding
import FeatureAuth
import FeatureMain
import FeaturePurchase

final class RootContainer {
    private(set) lazy var configContainer = ConfigContainer()
    private(set) lazy var notificationContainer = NotificationContainer()

    // MARK: - shared dependency
    private let remoteConfigRepository = FirebaseRemoteConfigRepository()
    private let onboardingRepository = OnboardingRepositoryImpl(
        preferenceDataSource: .standard,
        preferenceKey: "isPassedOnboarding"
    )

    private lazy var nonceProvider = CryptoNonceProvider()
    private lazy var topViewControllerProvider = UIKitTopViewControllerProvider()

    private lazy var googleAuthProvider = GoogleAuthProviderImpl(
        topViewControllerProvider: topViewControllerProvider
    )

    private lazy var appleAuthProvider = AppleAuthProviderImpl(
        nonceProvider: nonceProvider,
        topViewControllerProvider: topViewControllerProvider
    )

    private lazy var facebookAuthProvider      = FacebookAuthProviderImpl(
        nonceProvider: nonceProvider,
        topViewControllerProvider: topViewControllerProvider,
    )

    lazy var authRepository            = {
        let authDataSource            = FirebaseAuthDataSource(
            googleAuthProvider: googleAuthProvider,
            appleAuthProvider: appleAuthProvider,
            facebookAuthProvider: facebookAuthProvider
        )
        return AuthRepositoryImpl(authDataSource: authDataSource)
    }()

    lazy var accountRepository         = {
        let accountDataSource = FirebaseAccountDataSource(
            googleAuthProvider: googleAuthProvider,
            appleAuthProvider: appleAuthProvider,
            facebookAuthProvider: facebookAuthProvider
        )
        return AccountRepositoryImpl(accountDataSource: accountDataSource)
    }()

    lazy var analyticsTracker          = FirebaseAnalyticsTracker()

    // MARK: - shared containers
    private lazy var dataContainer        = DataContainer()

    private lazy var domainContainer      = DomainContainer(
        onboardingRepository: onboardingRepository,
        remoteConfigRepository: remoteConfigRepository
    )

    // MARK: - feature containers
    private lazy var authContainer         = AuthContainer(
        authRepository: authRepository,
        analyticsTracker: analyticsTracker
    )
    private lazy var mainContainer         = MainContainer(
        accountRepository: accountRepository,
        analyticsTracker: analyticsTracker
    )
    private lazy var purchaseContainer     = PurchaseContainer()
}

protocol RootCoordinatorFactory {
    func makeRootCoordinator() -> RootCoordinator
}

@MainActor
extension RootContainer: RootCoordinatorFactory {

    func makeRootCoordinator() -> RootCoordinator {
        let rootViewFactory = makeRootViewFactory()
        let alertFactory = RootAlertFactoryImpl()
        let rootSheetFactory = RootSheetFactoryImpl()
        let rootObserver = makeRootObserver()

        return RootCoordinator(
            rootViewFactory: rootViewFactory,
            alertFactory: alertFactory,
            rootSheetFactory: rootSheetFactory,
            rootObserver: rootObserver,
        )
    }

    private func makeRootViewFactory() -> any RootViewFactory {
        let onboardingViewFactory = OnboardingViewFactory(
            completeOnboardingUseCase: domainContainer.completeOnboardingUseCase
        )

        let splashViewFactory = SplashViewFactory(
            networkStatusObserver: dataContainer.networkStatusObserver,
            fetchRemoteConfigUseCase: domainContainer.fetchRemoteConfigUseCase,
            authStateObserver: dataContainer.authStateObserver,
            checkOnboardingPassedUseCase: domainContainer.checkOnboardingPassedUseCase
        )

        let authViewFactory = AuthViewFactory(
            cooldownTimerUseCase: domainContainer.cooldownTimerUseCase,
            loginUseCase: authContainer.loginUseCase,
            completeEmailVerificationUseCase: authContainer.completeEmailVerificationUseCase,
            sendEmailVerificationUseCase: authContainer.sendEmailVerificationUseCase,
            registerUseCase: authContainer.registerUseCase,
            sendPasswordResetUseCase: authContainer.sendPasswordResetUseCase
        )

        let tabFlowViewFactory = makeTabFlowViewFactory()

        return RootViewFactoryImpl(
            onboardingViewFactory: onboardingViewFactory,
            splashViewFactory: splashViewFactory,
            authViewFactory: authViewFactory,
            tabFlowViewFactory: tabFlowViewFactory,
        )
    }

    private func makeRootObserver() -> RootObserver {
        return RootObserver(
            networkStatusObserver: dataContainer.networkStatusObserver,
            authStateObserver: dataContainer.authStateObserver,
            notificationEventObserver: notificationContainer.notificationEventObserver,
        )
    }

    private func makeTabFlowViewFactory() -> any TabFlowViewFactory {
        let mainViewFactory = MainViewFactory(
            logOutUseCase: mainContainer.logOutUseCase,
            userAnonymousUseCase: mainContainer.userAnonymousUseCase,
            deleteAccountUseCase: mainContainer.deleteAccountUseCase,
        )

        return TabFlowViewFactoryImpl(
            mainViewFactory: mainViewFactory,
        )
    }
}
