import ProjectDescription
import HambugPlugin

let project = Project(
  name: "ThirdParty",
  targets: [
    .makeFrameworkTarget(
      name: "KakaoLogin",
      sources: ["Sources/KakaoLogin/**"],
      dependencies: [
        .external(name: "KakaoSDKCommon"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser"),
      ]
    ),
    .makeFrameworkTarget(
      name: "FCMService",
      sources: ["Sources/FCMService/**"],
      dependencies: [
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseCore"),
        .external(name: "FirebaseMessaging"),
        .project(target: "NetworkInterface", path: .relativeToRoot("Projects/Infrastructure")),
        .project(target: "DataSources", path: .relativeToRoot("Projects/Core")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
      ]
    ),
  ]
)
