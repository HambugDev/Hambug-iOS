// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "3rdParty",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "KakaoLogin",
      targets: ["KakaoLogin"]
    ),
    .library(
      name: "FCMService",
      targets: ["FCMService"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master"),
    .package(
      url: "https://github.com/firebase/firebase-ios-sdk.git",
      .upToNextMajor(from: "12.7.0")
    ),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "Common", path: "../Common")
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
    .target(
      name: "FCMService",
      dependencies: [
        .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
        .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
        .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
        .product(name: "NetworkInterface", package: "Infrastructure"),
        .product(name: "Util", package: "Common")
      ]
    )
    
  ]
)
