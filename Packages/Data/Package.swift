// swift-tools-version: 6.2
import PackageDescription

fileprivate let packageName = "Data"
fileprivate let googleSignInPackageName = "GoogleSignIn-iOS"
fileprivate let facebookPackageName = "facebook-ios-sdk"
fileprivate let alamofirePackageName = "Alamofire"
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
        .package(path: "../Telemetry"),
        .package(path: "../Environment"),

        // External SDKs
        .package(url: "https://github.com/Alamofire/\(alamofirePackageName).git", exact: "5.12.0"),
        .package(url: "https://github.com/firebase/\(firebasePackageName).git", exact: "12.17.0"),
        .package(url: "https://github.com/google/\(googleSignInPackageName).git", exact: "9.2.0"),
        .package(url: "https://github.com/facebook/\(facebookPackageName).git", exact: "17.1.0"),
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                // Local Dependencies
                .product(name: "Domain", package: "Domain"),
                .product(name: "Telemetry", package: "Telemetry"),
                .product(name: "Environment", package: "Environment"),

                // External Dependencies
                .product(name: "Alamofire", package: alamofirePackageName),
                .product(name: "FirebaseAuth", package: firebasePackageName),
                .product(name: "FirebaseRemoteConfig", package: firebasePackageName),
                    .product(name: "GoogleSignIn", package: googleSignInPackageName),
                .product(name: "FacebookLogin", package: facebookPackageName),
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
