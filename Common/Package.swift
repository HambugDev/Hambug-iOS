// swift-tools-version: 6.2
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
      name: "DIKit",
      targets: ["DIKit"]
    ),
    .library(
      name: "LocalizedString",
      targets: ["LocalizedString"]
    ),
    .library(
      name: "Util",
      targets: ["Util"]
    ),
    .library(
      name: "SharedUI",
      targets: ["SharedUI"]
    ),
    .library(
      name: "SharedDomain",
      targets: ["SharedDomain"]
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
      ],
      plugins: ["AssetContants"]
    ),
    .target(name: "DataSources"),
    .target(name: "DIKit"),
    .target(name: "LocalizedString"),
    .target(name: "Util"),
    .target(
      name: "SharedUI",
      dependencies: ["DesignSystem"]
    ),
    .target(name: "SharedDomain"),
    .executableTarget(name: "AssetContantsExec", path: "Plugins/AssetContantsExec"),
    .plugin(name: "AssetContants", capability: .buildTool(), dependencies: ["AssetContantsExec"])
  ]
)
