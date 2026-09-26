// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "Presentation"

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
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                // Local Dependencies
                .product(name: "Domain", package: "Domain"),
                .product(name: "Environment", package: "Environment"),
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
