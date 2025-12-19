// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "3rdParth",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "KakaoLogin",
      targets: ["KakaoLogin"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master"),
  ],
  targets: [
    .target(
      name: "KakaoLogin",
      dependencies: [
        .product(name: "KakaoSDKCommon", package: "kakao-ios-sdk"),
        .product(name: "KakaoSDKAuth", package: "kakao-ios-sdk"),
        .product(name: "KakaoSDKUser", package: "kakao-ios-sdk"),
      ]
    ),
    
  ]
)
