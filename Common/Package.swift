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
        .library(
            name: "DataSources",
            targets: ["DataSources"]
        ),
    ],
    targets: [
        .target(
            name: "Managers",
            dependencies: ["DataSources"]
        ),
        .target(
            name: "DesignSystem",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "DataSources"
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
