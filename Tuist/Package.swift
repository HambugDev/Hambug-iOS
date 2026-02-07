// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  baseSettings: .settings(base: [
    "SWIFT_VERSION": "6",
  ])
)
#endif

let package = Package(
  name: "Hambug",
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.7.0")),
    .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master"),
  ]
)
