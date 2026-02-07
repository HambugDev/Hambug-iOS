import ProjectDescription
import HambugPlugin

let project = Project(
  name: "Presentation",
  targets: [
    .makeFrameworkTarget(
      name: "AlarmPresentation",
      sources: ["Sources/Alarm/**"],
      dependencies: [
        .project(target: "AlarmDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/Core")),
      ]
    ),
    .makeFrameworkTarget(
      name: "CommunityPresentation",
      sources: ["Sources/Community/**"],
      resources: ["Sources/Community/Assets.xcassets"],
      dependencies: [
        .project(target: "CommunityDomain", path: .relativeToRoot("Projects/Domain")),
        .target(name: "AlarmPresentation"),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/Core")),
        .project(target: "SharedUI", path: .relativeToRoot("Projects/Core")),
        .project(target: "Managers", path: .relativeToRoot("Projects/Core")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
      ]
    ),
    .makeFrameworkTarget(
      name: "HomePresentation",
      sources: ["Sources/Home/**"],
      dependencies: [
        .project(target: "HomeDomain", path: .relativeToRoot("Projects/Domain")),
        .target(name: "CommunityPresentation"),
        .target(name: "AlarmPresentation"),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/Core")),
        .project(target: "SharedUI", path: .relativeToRoot("Projects/Core")),
      ]
    ),
    .makeFrameworkTarget(
      name: "MyPagePresentation",
      sources: ["Sources/MyPage/**"],
      resources: ["Sources/MyPage/Assets.xcassets"],
      dependencies: [
        .project(target: "MyPageDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "CommunityDomain", path: .relativeToRoot("Projects/Domain")),
        .target(name: "CommunityPresentation"),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/Core")),
        .project(target: "SharedUI", path: .relativeToRoot("Projects/Core")),
        .project(target: "LocalizedString", path: .relativeToRoot("Projects/Core")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
      ]
    ),
    .makeFrameworkTarget(
      name: "LoginPresentation",
      sources: ["Sources/Login/**"],
      dependencies: [
        .project(target: "LoginDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/Core")),
        .project(target: "Managers", path: .relativeToRoot("Projects/Core")),
        .project(target: "LocalizedString", path: .relativeToRoot("Projects/Core")),
      ]
    ),
    .makeFrameworkTarget(
      name: "IntroPresentation",
      sources: ["Sources/Intro/**"],
      resources: ["Sources/Intro/Image.xcassets"],
      dependencies: [
        .project(target: "Managers", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/Core")),
      ]
    ),
  ]
)
