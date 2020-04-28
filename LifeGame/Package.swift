// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LifeGame",
    products: [
        .library(
            name: "LifeGame",
            targets: ["LifeGame"]),
    ],
    dependencies: [
      .package(name: "JavaScriptKit", url: "https://github.com/kateinoigakukun/JavaScriptKit.git", .branch("master")),
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
