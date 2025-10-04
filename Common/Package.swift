// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Managers",
            targets: ["Managers"]
        ),
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
    ],
    targets: [
        .target(
            name: "Managers"
        ),
        .target(
            name: "DesignSystem",
            resources: [
                .process("Color.xcassets")
            ]
        ),
        .plugin(
            name: "ColorGenerator",
            capability: .command(
                intent: .custom(
                    verb: "generate-colors",
                    description: "Generate color constants from xcassets"
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "Generate DesignSystem+Color.swift file")
                ]
            )
        ),
    ]
)
