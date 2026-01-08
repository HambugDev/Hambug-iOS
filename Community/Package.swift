// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "Community"

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
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
  ],
  targets: [
    // Domain: 독립적 (외부 의존성 없음)
    .target(
      name: Config.domain.name,
      dependencies: [
        .product(name: "NetworkInterface", package: "Infrastructure"),
      ],
      path: Config.domain.path
    ),

    // Data: Domain, Network에 의존
    .target(
      name: Config.data.name,
      dependencies: [
        .target(config: .domain),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "NetworkImpl", package: "Infrastructure"),
      ],
      path: Config.data.path
    ),

    // Presentation: Domain, DesignSystem에 의존
    .target(
      name: Config.presentation.name,
      dependencies: [
        .target(config: .domain),
        .product(name: "DesignSystem", package: "Common"),
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
