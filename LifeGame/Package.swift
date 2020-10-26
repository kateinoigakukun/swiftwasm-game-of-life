// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LifeGame",
    products: [
        .executable(
            name: "LifeGameWeb",
            targets: ["LifeGameWeb"]),
    ],
    dependencies: [
        .package(
            name: "JavaScriptKit",
            url: "https://github.com/swiftwasm/JavaScriptKit.git",
            from: "0.6.0"
        ),
    ],
    targets: [
        .target(
            name: "LifeGameWeb",
            dependencies: ["LifeGame", "JavaScriptKit"]),
        .target(
            name: "LifeGame",
            dependencies: []),
        .testTarget(
            name: "LifeGameTests",
            dependencies: ["LifeGame"]),
    ]
)
