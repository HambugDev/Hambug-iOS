// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "Home"

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
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(name: "DI", path: "../DI"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "Community", path: "../Community"),
  ],
  targets: [
    .target(
      config: .di,
      dependencies: [
        .target(config: .domain),
        .target(config: .data),
        .target(config: .presentation),
        .product(name: "DI", package: "DI"),
        .product(name: "AppDI", package: "DI"),
        .product(name: "Managers", package: "Common"),
        .product(name: "DataSources", package: "Common"),
      ],
    ),
    // Domain: 의존하지않음
    .target(
      config: .domain,
      dependencies: [
        .product(name: "CommunityDomain", package: "Community")
      ]
    ),

    // Data: Domain에 의존
    .target(
      config: .data,
      dependencies: [
        .target(config: .domain),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "Util", package: "Common"),
        .product(name: "SharedDomain", package: "Common"),
        .product(name: "CommunityDomain", package: "Community"),
      ],
    ),

    // Presentation: Domain, DesignSystem, SharedUI에 의존
    .target(
      config: .presentation,
      dependencies: [
        .target(config: .domain),
        .product(name: "DesignSystem", package: "Common"),
        .product(name: "SharedUI", package: "Common"),
        .product(name: "Community", package: "Community"),
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
