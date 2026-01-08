// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "Login"
  
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
  platforms: [
    .iOS(.v17)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: Config.name,
      targets: Config.allCases.map(\.name)
    ),
  ],
  dependencies: [
    .package(name: "3rdParty", path: "../3rdParty"),
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure")
  ],
  targets: [
    // Domain: 독립적 (외부 SDK만 의존)
    .target(
      name: Config.domain.name,
      dependencies: [
        .product(name: "KakaoLogin", package: "3rdParty"),
      ],
      path: Config.domain.path
    ),
    
    // Data: Domain에 의존
    .target(
      name: Config.data.name,
      dependencies: [
        .target(config: Config.domain),
        .product(name: "DataSources", package: "Common"),
        .product(name: "Util", package: "Common"),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "NetworkImpl", package: "Infrastructure")
      ],
      path: Config.data.path
    ),
    
    // Presentation: Domain에 의존
    .target(
      name: Config.presentation.name,
      dependencies: [
        .target(config: Config.domain),
        .product(name: "LocalizedString", package: "Common"),
        .product(name: "Managers", package: "Common"),
        .product(name: "DesignSystem", package: "Common")
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
