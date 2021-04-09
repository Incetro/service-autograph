// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "service-autograph",
    dependencies: [
        .package(
            name: "Autograph",
            url: "https://github.com/Incetro/autograph",
            .branch("main")
        ),
        .package(
            name: "swift-argument-parser",
            url: "https://github.com/apple/swift-argument-parser.git",
            .upToNextMinor(from: "0.3.1")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "service-autograph",
            dependencies: [
                "Autograph",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "service-autographTests",
            dependencies: [
                "service-autograph"
            ]
        ),
    ]
)
