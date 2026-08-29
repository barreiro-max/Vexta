// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "Configuration"
fileprivate let googleSignInPackageName = "GoogleSignIn-iOS"
fileprivate let facebookPackageName = "facebook-ios-sdk"
fileprivate let firebasePackageName = "firebase-ios-sdk"
fileprivate let revenueCatPackageName = "purchases-ios"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v18)],
    products: [
        .library(name: packageName, targets: [packageName]),
    ],
    dependencies: [
        // Local Packages
        .package(path: "../Telemetry"),
        .package(path: "../Environment"),

        // External SDKs
        .package(url: "https://github.com/google/\(googleSignInPackageName).git", exact: "9.2.0"),
        .package(url: "https://github.com/facebook/\(facebookPackageName).git", exact: "17.1.0"),
        .package(url: "https://github.com/firebase/\(firebasePackageName).git", exact: "12.17.0"),
        .package(url: "https://github.com/RevenueCat/\(revenueCatPackageName).git", exact: "5.16.0"),    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                // Local Dependencies
                .product(name: "Telemetry", package: "Telemetry"),
                .product(name: "Environment", package: "Environment"),

                // External Dependencies
                .product(name: "GoogleSignIn", package: googleSignInPackageName),
                .product(name: "FacebookCore", package: facebookPackageName),

                .product(name: "FirebaseCore", package: firebasePackageName),
                .product(name: "FirebaseAuth", package: firebasePackageName),
                .product(name: "FirebaseRemoteConfig", package: firebasePackageName),

                .product(name: "RevenueCat", package: revenueCatPackageName),
            ]
        ),
        .testTarget(
            name: "\(packageName)Tests",
            dependencies: [
                .target(name: packageName),
            ]
        ),
    ]
)
