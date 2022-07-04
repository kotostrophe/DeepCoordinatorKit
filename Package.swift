// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeepCoordinatorKit",
    products: [
        .library(name: "DeepCoordinatorKit", targets: ["DeepCoordinatorKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kotostrophe/CoordinatorKit", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(name: "DeepCoordinatorKit", dependencies: ["CoordinatorKit", "SwiftyJSON"]),
        .testTarget(name: "DeepCoordinatorKitTests", dependencies: ["DeepCoordinatorKit"]),
    ]
)
