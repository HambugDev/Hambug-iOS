// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Common",
  platforms: [.iOS(.v17)],
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
    .library(
      name: "LocalizedString",
      targets: ["LocalizedString"]
    ),
    .library(
      name: "Util",
      targets: ["Util"]
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
        .process("Resources/Font")
      ]
    ),
    .target(name: "DataSources"),
    .target(name: "LocalizedString"),
    .target(name: "Util"),
    
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
