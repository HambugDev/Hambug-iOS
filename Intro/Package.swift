// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Intro",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(
            name: "Onboarding",
            targets: ["Onboarding"]
        ),
        .library(
            name: "Splash",
            targets: ["Splash"]
        ),
    ],
    dependencies: [
        .package(name: "Common", path: "../Common")
    ],
    targets: [
        .target(
            name: "Onboarding",
            dependencies: [
                .product(name: "Managers", package: "Common"),
                .product(name: "DesignSystem", package: "Common")
            ]
        ),
        .target(
            name: "Splash",
            dependencies: [
                .product(name: "Managers", package: "Common"),
                .product(name: "DesignSystem", package: "Common")
            ],
        ),
    ]
)
