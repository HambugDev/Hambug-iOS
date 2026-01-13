// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "DI"

  case interface = "DI"
  case app = "App"
  case intro = "Intro"
  case login = "Login"

  var name: String {
    switch self {
    case .interface: "\(rawValue)Kit"
    default: "\(rawValue)DI"
    }

  }
}
let package = Package(
  name: Config.name,
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: Config.interface.name,
      targets: Config.allCases.map(\.name)
    ),
    .library(
      name: Config.interface.rawValue,
      targets: [Config.interface.name]
    ),
    .library(
      name: Config.app.name,
      targets: [Config.app.name]
    )
  ],
  dependencies: [
    .package(name: "3rdParty", path: "../3rdParty"),
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "Intro", path: "../Intro"),
    .package(name: "Login", path: "../Login"),
  ],
  targets: [
    .target(name: Config.interface.name),
    .target(
      name: Config.app.name,
      dependencies: [
        .target(config: .interface),
        .product(name: "DataSources", package: "Common"),
        .product(name: "Managers", package: "Common"),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "NetworkImpl", package: "Infrastructure"),
        .product(name: "FCMService", package: "3rdParty"),
      ]
    ),
    .target(
      name: Config.intro.name,
      dependencies: [
        .target(config: .app),
        .product(name: "Onboarding", package: "Intro"),
        .product(name: "Splash", package: "Intro"),
      ]
    ),
    .target(
      name: Config.login.name,
      dependencies: [
        .target(config: .app),
        .product(name: "Login", package: "Login"),
      ]
    )
  ]
)

extension Target.Dependency {
  static func target(config: Config) -> Self {
    .target(name: config.name)
  }
}
