// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "AppCore"
  
  case di = "DI"
  
  var name: String {
    return "\(Config.name)\(rawValue)"
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
      name: "AppCore",
      targets: Config.allCases.map(\.name)
    ),
  ],
  dependencies: [
    .package(name: "Intro", path: "../Intro"),
    .package(name: "Login", path: "../Login"),
    .package(name: "Home", path: "../Home"),
    .package(name: "Community", path: "../Community"),
    .package(name: "MyPage", path: "../MyPage"),
    .package(name: "Alarm", path: "../Alarm"),
    
    .package(name: "3rdParty", path: "../3rdParty"),
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
  ],
  targets: [
    .target(
      config: .di,
      dependencies: [
        .product(name: "DataSources", package: "Common"),
        .product(name: "Managers", package: "Common"),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "NetworkImpl", package: "Infrastructure"),
        .product(name: "FCMService", package: "3rdParty"),
        
        .product(name: "IntroDI", package: "Intro"),
        .product(name: "LoginDI", package: "Login"),
        .product(name: "HomeDI", package: "Home"),
        .product(name: "CommunityDI", package: "Community"),
        .product(name: "MyPageDI", package: "MyPage"),
        .product(name: "AlarmDI", package: "Alarm"),
      ]
    )
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
