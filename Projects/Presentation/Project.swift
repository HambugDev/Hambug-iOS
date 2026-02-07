import ProjectDescription
import HambugPlugin

let project = Project(
  name: Module.presentation.rawValue,
  targets: [
    .makeFrameworkTarget(
      name: Module.Presentation.alarm.name,
      sources: ["Sources/Alarm/**"],
      dependencies: [
        Module.Domain.alarm.dependency,
        Module.Core.designSystem.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Presentation.community.name,
      sources: ["Sources/Community/**"],
      resources: ["Sources/Community/Assets.xcassets"],
      dependencies: [
        Module.Domain.community.dependency,
        Module.Presentation.alarm.target,
        Module.Core.designSystem.dependency,
        Module.Core.sharedUI.dependency,
        Module.Core.managers.dependency,
        Module.Core.util.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Presentation.home.name,
      sources: ["Sources/Home/**"],
      dependencies: [
        Module.Domain.home.dependency,
        Module.Presentation.community.target,
        Module.Presentation.alarm.target,
        Module.Core.designSystem.dependency,
        Module.Core.sharedUI.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Presentation.myPage.name,
      sources: ["Sources/MyPage/**"],
      resources: ["Sources/MyPage/Assets.xcassets"],
      dependencies: [
        Module.Domain.myPage.dependency,
        Module.Domain.community.dependency,
        Module.Presentation.community.target,
        Module.Core.designSystem.dependency,
        Module.Core.sharedUI.dependency,
        Module.Core.localizedString.dependency,
        Module.Core.util.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Presentation.login.name,
      sources: ["Sources/Login/**"],
      dependencies: [
        Module.Domain.login.dependency,
        Module.Core.designSystem.dependency,
        Module.Core.managers.dependency,
        Module.Core.localizedString.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Presentation.intro.name,
      sources: ["Sources/Intro/**"],
      resources: ["Sources/Intro/Image.xcassets"],
      dependencies: [
        Module.Core.managers.dependency,
        Module.Core.designSystem.dependency,
      ]
    ),
  ]
)
