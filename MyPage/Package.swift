// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Config: String, CaseIterable {
  static let name: String = "MyPage"
  
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
  targets: [
    .target(
      name: Config.data.name,
      path: Config.data.path
    ),
    .target(
      name: Config.domain.name,
      path: Config.domain.path
    ),
    .target(
      name: Config.presentation.name,
      path: Config.presentation.path
    ),
    
  ]
)

extension Target.Dependency {
  static func target(config: Config) -> Self {
    return .target(name: config.name)
  }
}
