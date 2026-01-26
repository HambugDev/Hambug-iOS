// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "Intro"
  
  case di = "DI"
  case onboarding = "Onboarding"
  case splash = "Splash"
  
  var name: String {
    switch self {
    case .di:
      return Config.name + rawValue
    case .onboarding, .splash:
      return rawValue
    }
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
    .library(
      name: Config.di.name,
      targets: [Config.di.name]
    ),
    .library(
      name: Config.onboarding.name,
      targets: [Config.onboarding.name]
    ),
    .library(
      name: Config.splash.name,
      targets: [Config.splash.name]
    ),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common")
  ],
  targets: [
    .target(
      config: .di,
      dependencies: [
        .target(config: .onboarding),
        .target(config: .splash),
      ]
    ),
    .target(
      config: .onboarding,
      dependencies: [
        .product(name: "Managers", package: "Common"),
        .product(name: "DesignSystem", package: "Common")
      ]
    ),
    .target(
      config: .splash,
      dependencies: [
        .product(name: "Managers", package: "Common"),
        .product(name: "DesignSystem", package: "Common")
      ],
    ),
  ]
)

extension Target {
  static func target(
    config: Config,
    dependencies: [Dependency] = [],
    exclude: [String] = [],
    sources: [String]? = nil,
    resources: [Resource]? = nil,
    publicHeadersPath: String? = nil,
    packageAccess: Bool = false,
    cSettings: [CSetting]? = nil,
    cxxSettings: [CXXSetting]? = nil,
    swiftSettings: [SwiftSetting]? = nil,
    linkerSettings: [LinkerSetting]? = nil,
    plugins: [PluginUsage]? = nil,
  ) -> Target {
    return .target(
      name: config.name,
      dependencies: dependencies,
      path: config.path,
      exclude: exclude,
      sources: sources,
      resources: resources,
      publicHeadersPath: publicHeadersPath,
      packageAccess: packageAccess,
      cSettings: cSettings,
      cxxSettings: cxxSettings,
      swiftSettings: swiftSettings,
      linkerSettings: linkerSettings,
      plugins: plugins)
  }
}

extension Target.Dependency {
  static func target(config: Config) -> Self {
    return .target(name: config.name)
  }
}
