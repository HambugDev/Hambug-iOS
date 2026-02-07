import ProjectDescription
import HambugPlugin

let project = Project(
  name: Module.domain.rawValue,
  targets: [
    .makeFrameworkTarget(
      name: Module.Domain.shared.name,
      sources: ["Sources/Shared/**"]
    ),
    .makeFrameworkTarget(
      name: Module.Domain.community.name,
      sources: ["Sources/Community/**"]
    ),
    .makeFrameworkTarget(
      name: Module.Domain.home.name,
      sources: ["Sources/Home/**"],
      dependencies: [
        Module.Domain.community.target,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Domain.myPage.name,
      sources: ["Sources/MyPage/**"],
      dependencies: [
        Module.Domain.community.target,
        Module.Domain.shared.target,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Domain.login.name,
      sources: ["Sources/Login/**"],
      dependencies: [
        Module.ThirdParty.kakaoLogin.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Domain.alarm.name,
      sources: ["Sources/Alarm/**"]
    ),
  ]
)
