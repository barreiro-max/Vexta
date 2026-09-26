// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "Root"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v18)],
    products: [
        .library(name: packageName, targets: [packageName]),
    ],
    dependencies: [
        // MARK: - Shared Packages
        .package(path: "../Domain"),
        .package(path: "../Data"),
        .package(path: "../Presentation"),
        .package(path: "../Telemetry"),
        .package(path: "../Notification"),
        .package(path: "../Environment"),
        .package(path: "../Configuration"),

        // MARK: - Feature Packages
        .package(path: "../FeatureSplash"),
        .package(path: "../FeatureOnboarding"),
        .package(path: "../FeatureAuth"),
        .package(path: "../FeaturePurchase"),
        .package(path: "../FeatureMain"),
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                // Shared Dependencies
                .product(name: "Domain", package: "Domain"),
                .product(name: "Data", package: "Data"),
                .product(name: "Presentation", package: "Presentation"),
                .product(name: "Telemetry", package: "Telemetry"),
                .product(name: "Notification", package: "Notification"),
                .product(name: "Environment", package: "Environment"),
                .product(name: "Configuration", package: "Configuration"),

                // Feature Dependencies
                .product(name: "FeatureSplash", package: "FeatureSplash"),
                .product(name: "FeatureOnboarding", package: "FeatureOnboarding"),
                .product(name: "FeatureAuth", package: "FeatureAuth"),
                .product(name: "FeaturePurchase", package: "FeaturePurchase"),
                .product(name: "FeatureMain", package: "FeatureMain"),
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
