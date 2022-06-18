// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeepCoordinatorKit",
    products: [
        .library(name: "DeepCoordinatorKit", targets: ["DeepCoordinatorKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kotostrophe/CoordinatorKit", branch: "main")
    ],
    targets: [
        .target(name: "DeepCoordinatorKit", dependencies: ["CoordinatorKit"]),
        .testTarget(name: "DeepCoordinatorKitTests", dependencies: ["DeepCoordinatorKit"]),
    ]
)
