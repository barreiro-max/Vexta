// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "Telemetry"
fileprivate let firebasePackageName = "firebase-ios-sdk"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v18)],
    products: [
        .library(name: packageName, targets: [packageName]),
    ],
    dependencies: [
        // Local Packages
        .package(path: "../Domain"),
        .package(path: "../Environment"),

        // External SDKs
        .package(url: "https://github.com/firebase/\(firebasePackageName).git", exact: "12.17.0"),
    ],
    targets: [
        .target(
            name: "Telemetry",
            dependencies: [
                // Local Dependencies
                .product(name: "Domain", package: "Domain"),
                .product(name: "Environment", package: "Environment"),

                // External Dependencies
                .product(name: "FirebaseAnalytics", package: firebasePackageName),
                .product(name: "FirebaseCrashlytics", package: firebasePackageName),
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
