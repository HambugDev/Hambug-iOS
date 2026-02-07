import ProjectDescription
import HambugPlugin

let project = Project(
  name: "Domain",
  targets: [
    .makeFrameworkTarget(
      name: "SharedDomain",
      sources: ["Sources/Shared/**"]
    ),
    .makeFrameworkTarget(
      name: "CommunityDomain",
      sources: ["Sources/Community/**"]
    ),
    .makeFrameworkTarget(
      name: "HomeDomain",
      sources: ["Sources/Home/**"],
      dependencies: [
        .target(name: "CommunityDomain"),
      ]
    ),
    .makeFrameworkTarget(
      name: "MyPageDomain",
      sources: ["Sources/MyPage/**"],
      dependencies: [
        .target(name: "CommunityDomain"),
        .target(name: "SharedDomain"),
      ]
    ),
    .makeFrameworkTarget(
      name: "LoginDomain",
      sources: ["Sources/Login/**"],
      dependencies: [
        .project(target: "KakaoLogin", path: .relativeToRoot("Projects/ThirdParty")),
      ]
    ),
    .makeFrameworkTarget(
      name: "AlarmDomain",
      sources: ["Sources/Alarm/**"]
    ),
  ]
)
