// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "FeatureSplash"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v18)],
    products: [
        .library(name: packageName, targets: [packageName]),
    ],
    dependencies: [
        // Local Packages
        .package(path: "../Domain"),
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                // Local Dependencies
                .product(name: "Domain", package: "Domain"),
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
