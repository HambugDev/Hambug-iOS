// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "DI"

  case interface = "DI"
  case app = "App"
  case intro = "Intro"
  case login = "Login"
  case myPage = "MyPage"

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
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "Intro", path: "../Intro"),
    .package(name: "Login", path: "../Login"),
    .package(name: "MyPage", path: "../MyPage"),
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
        .product(name: "NetworkImpl", package: "Infrastructure")
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
    ),
    .target(
      name: Config.myPage.name,
      dependencies: [
        .target(config: .app),
        .product(name: "MyPage", package: "MyPage"),
      ]
    ),
    .target(
      name: Config.community.name,
      dependencies: [
        .target(config: .app),
        .product(name: "Community", package: "Community"),
      ]
    )
  ]
)

extension Target.Dependency {
  static func target(config: Config) -> Self {
    .target(name: config.name)
  }
}
