// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct Config {
  static let name: String = "Login"
  static let data: String = name + "Data"
  static let domain: String = name + "Domain"
  static let presentation: String = name + "Presentation"
  static let infrastructure: String = name + "Infrastructure"
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
      targets: [Config.data, Config.domain, Config.presentation]
    ),
  ],
  dependencies: [
    .package(name: "3rdParth", path: "../3rdParth"),
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure")
  ],
  targets: [
    // Domain: 독립적 (외부 SDK만 의존)
    .target(
      name: Config.domain,
      dependencies: [
        .product(name: "KakaoLogin", package: "3rdParth"),
      ],
      path: "Sources/Domain"
    ),
    
    // Data: Domain에 의존
    .target(
      name: Config.data,
      dependencies: [
        .target(name: Config.domain),
        .product(name: "DataSources", package: "Common"),
        .product(name: "NetworkCommon", package: "Infrastructure"),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "NetworkImpl", package: "Infrastructure")
      ],
      path: "Sources/Data"
    ),
    
    // Presentation: Domain에 의존
    .target(
      name: Config.presentation,
      dependencies: [
        .target(name: Config.domain),
        .product(name: "LocalizedString", package: "Common"),
        .product(name: "Managers", package: "Common"),
        .product(name: "DesignSystem", package: "Common")
      ],
      path: "Sources/Presentation"
    ),
  ]
)

