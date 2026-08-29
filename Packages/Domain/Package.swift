// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "Domain"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v18)],
    products: [
        .library(name: packageName, targets: [packageName]),
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: []
        ),
        .testTarget(
            name: "\(packageName)Tests",
            dependencies: [
                .target(name: packageName),
            ]
        ),
    ]
)
