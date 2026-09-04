// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "FeatureAuth"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v18)],
    products: [
        .library(name: packageName, targets: [packageName]),
    ],
    dependencies: [
        // Local Packages
        .package(path: "../Domain"),
        .package(path: "../Data"),
        .package(path: "../Presentation"),
        .package(path: "../Telemetry"),
        .package(path: "../Notification"),
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                // Local Dependencies
                .product(name: "Domain", package: "Domain"),
                .product(name: "Data", package: "Data"),
                .product(name: "Presentation", package: "Presentation"),
                .product(name: "Telemetry", package: "Telemetry"),
                .product(name: "Notification", package: "Notification"),
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
