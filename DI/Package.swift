// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DI",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "DIKit",
      targets: ["DIKit"]
    ),
    .library(
      name: "AppDI",
      targets: ["AppDI"]
    ),
    .library(
      name: "IntroDI",
      targets: ["IntroDI"]
    ),
    .library(
      name: "LoginDI",
      targets: ["LoginDI"]
    )
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "Intro", path: "../Intro"),
    .package(name: "Login", path: "../Login"),
  ],
  targets: [
    .target(name: "DIKit"),
    .target(
      name: "AppDI",
      dependencies: [
        .target(name: "DIKit"),
        .product(name: "DataSources", package: "Common"),
        .product(name: "Managers", package: "Common"),
        .product(name: "NetworkCommon", package: "Infrastructure"),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "NetworkImpl", package: "Infrastructure")
      ]
    ),
    .target(
      name: "IntroDI",
      dependencies: [
        .target(name: "AppDI"),
        .product(name: "Onboarding", package: "Intro"),
        .product(name: "Splash", package: "Intro"),
      ]
    ),
    .target(
      name: "LoginDI",
      dependencies: [
        .target(name: "AppDI"),
        .product(name: "Login", package: "Login"),
      ]
    )
  ]
)
