// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "MyPage"
  
  case di = "DI"
  case data = "Data"
  case domain = "Domain"
  case presentation = "Presentation"
  
  var name: String {
    Config.name + rawValue
  }
  
  var path: String {
    "Sources/\(rawValue)"
  }
}

let package = Package(
  name: Config.name,
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: Config.name,
      targets: Config.allCases.map(\.name)
    ),
    .library(
      name: Config.di.name,
      targets: [Config.di.name]
    ),
    .library(
      name: Config.presentation.name,
      targets: [Config.presentation.name]
    ),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "Community", path: "../Community"),
  ],
  targets: [
    .target(
      name: Config.di.name,
      dependencies: [
        .target(config: .domain),
        .target(config: .data),
        .target(config: .presentation),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "NetworkImpl", package: "Infrastructure"),
        .product(name: "DIKit", package: "Common"),
      ],
      path: Config.di.path
    ),
    .target(
      name: Config.data.name,
      dependencies: [
        .target(config: .domain),
        .product(name: "SharedDomain", package: "Common"),
        .product(name: "Util", package: "Common"),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "NetworkImpl", package: "Infrastructure"),
        .product(name: "CommunityDomain", package: "Community")
      ],
      path: Config.data.path
    ),
    .target(
      name: Config.domain.name,
      dependencies: [
        .product(name: "CommunityDomain", package: "Community")
      ],
      path: Config.domain.path
    ),
    .target(
      name: Config.presentation.name,
      dependencies: [
        .target(config: .domain),
        .product(name: "LocalizedString", package: "Common"),
        .product(name: "SharedUI", package: "Common"),
        .product(name: "DesignSystem", package: "Common"),
        .product(name: "Community", package: "Community"),
        .product(name: "CommunityDomain", package: "Community"),
        .product(name: "CommunityDI", package: "Community"),
      ],
      path: Config.presentation.path
    ),
    
  ]
)

extension Target.Dependency {
  static func target(config: Config) -> Self {
    return .target(name: config.name)
  }
}
