// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "FeaturePurchase"
fileprivate let revenueCatPackageName = "purchases-ios"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v18)],
    products: [
        .library(name: packageName, targets: [packageName]),
    ],
    dependencies: [
        // External SDKs
        .package(url: "https://github.com/RevenueCat/\(revenueCatPackageName).git", exact: "5.16.0"),
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                // External Dependencies
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
