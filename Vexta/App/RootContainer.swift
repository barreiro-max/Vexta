//
//  RootContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 14.06.2026.
//

// MARK: - Shared imports
import Configuration
import Environment
import Domain
import Data
import Presentation
import Telemetry

// MARK: - Feature imports
import FeatureSplash
import FeatureOnboarding
import FeatureAuth
import FeatureMain
import FeatureNotification
import FeaturePurchase

final class RootContainer {
    private(set) lazy var configContainer = ConfigContainer()

    // MARK: - shared dependency
    private let remoteConfigRepository = FirebaseRemoteConfigRepository()
    private let onboardingRepository = OnboardingRepositoryImpl(
        preferenceDataSource: .standard,
        preferenceKey: "isPassedOnboarding"
    )

    lazy var authRepository            = {
        let nonceProvider             = CryptoNonceProvider()
        let topViewControllerProvider = UIKitTopViewControllerProvider()

        let googleAuthProvider        = GoogleAuthProviderImpl(
            topViewControllerProvider: topViewControllerProvider
        )
        let appleAuthProvider         = AppleAuthProviderImpl(
            nonceProvider: nonceProvider,
            topViewControllerProvider: topViewControllerProvider
        )
        let facebookAuthProvider      = FacebookAuthProviderImpl(
            topViewControllerProvider: topViewControllerProvider
        )

        let authDataSource            = FirebaseAuthDataSource(
            googleAuthProvider: googleAuthProvider,
            appleAuthProvider: appleAuthProvider,
            facebookAuthProvider: facebookAuthProvider
        )
        return AuthRepositoryImpl(authDataSource: authDataSource)
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
        authRepository: authRepository,
        analyticsTracker: analyticsTracker
    )
    private lazy var notificationContainer = NotificationContainer()
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

        return RootCoordinator(
            rootViewFactory: rootViewFactory,
            alertFactory: alertFactory,
            rootSheetFactory: rootSheetFactory,
        )
    }

    private func makeRootViewFactory() -> any RootViewFactory {
        let onboardingViewFactory = OnboardingViewFactory(
            completeOnboardingUseCase: domainContainer.completeOnboardingUseCase
        )

        let splashViewFactory = SplashViewFactory(
            networkMonitor: dataContainer.networkMonitor,
            fetchRemoteConfigUseCase: domainContainer.fetchRemoteConfigUseCase,
            authStateObserver: dataContainer.authStateObserver,
            checkOnboardingPassedUseCase: domainContainer.checkOnboardingPassedUseCase
        )

        let authViewFactory = AuthViewFactory(
            loginUseCase: authContainer.loginUseCase,
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

    private func makeTabFlowViewFactory() -> any TabFlowViewFactory {
        let mainViewFactory = MainViewFactory(
            logOutUseCase: mainContainer.logOutUseCase,
        )

        return TabFlowViewFactoryImpl(
            mainViewFactory: mainViewFactory,
        )
    }
}
