import ProjectDescription
import HambugPlugin

let project = Project(
  name: "Data",
  targets: [
    .makeFrameworkTarget(
      name: "HomeData",
      sources: ["Sources/Home/**"],
      dependencies: [
        .project(target: "HomeDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "CommunityDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "SharedDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "NetworkInterface", path: .relativeToRoot("Projects/Infrastructure")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
      ]
    ),
    .makeFrameworkTarget(
      name: "CommunityData",
      sources: ["Sources/Community/**"],
      dependencies: [
        .project(target: "CommunityDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "NetworkInterface", path: .relativeToRoot("Projects/Infrastructure")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
      ]
    ),
    .makeFrameworkTarget(
      name: "MyPageData",
      sources: ["Sources/MyPage/**"],
      dependencies: [
        .project(target: "MyPageDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "CommunityDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "SharedDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "NetworkInterface", path: .relativeToRoot("Projects/Infrastructure")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
        .project(target: "Managers", path: .relativeToRoot("Projects/Core")),
      ]
    ),
    .makeFrameworkTarget(
      name: "LoginData",
      sources: ["Sources/Login/**"],
      dependencies: [
        .project(target: "LoginDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "DataSources", path: .relativeToRoot("Projects/Core")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
        .project(target: "Managers", path: .relativeToRoot("Projects/Core")),
        .project(target: "NetworkInterface", path: .relativeToRoot("Projects/Infrastructure")),
      ]
    ),
    .makeFrameworkTarget(
      name: "AlarmData",
      sources: ["Sources/Alarm/**"],
      dependencies: [
        .project(target: "AlarmDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "NetworkInterface", path: .relativeToRoot("Projects/Infrastructure")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
      ]
    ),
  ]
)
