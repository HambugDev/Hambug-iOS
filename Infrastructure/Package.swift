// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct Config {
  static let name: String = "Infrastructure"
  static let common: String = "NetworkCommon"
  static let networkImpl: String = "NetworkImpl"
  static let networkInterface: String = "NetworkInterface"
  
}

let package = Package(
  name: Config.name,
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: Config.common,
      targets: [Config.common]
    ),
    .library(
      name: Config.networkInterface,
      targets: [Config.networkInterface]
    ),
    .library(
      name: Config.networkImpl,
      targets: [Config.networkImpl]
    ),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0"),
  ],
  targets: [
    .target(
      name: Config.common
    ),
    .target(
      name: Config.networkInterface,
      dependencies: [
        .target(name: Config.common)
      ]
    ),
    .target(
      name: Config.networkImpl,
      dependencies: [
        .target(name: Config.common),
        .target(name: Config.networkInterface),
        .product(name: "DataSources", package: "Common"),
        "Alamofire",
      ]
    ),
    
    
  ]
)
