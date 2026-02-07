import ProjectDescription
import HambugPlugin

let project = Project(
  name: Module.data.rawValue,
  targets: [
    .makeFrameworkTarget(
      name: Module.Data.home.name,
      sources: ["Sources/Home/**"],
      dependencies: [
        Module.Domain.home.dependency,
        Module.Domain.community.dependency,
        Module.Domain.shared.dependency,
        Module.Infrastructure.networkInterface.dependency,
        Module.Core.util.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Data.community.name,
      sources: ["Sources/Community/**"],
      dependencies: [
        Module.Domain.community.dependency,
        Module.Infrastructure.networkInterface.dependency,
        Module.Core.util.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Data.myPage.name,
      sources: ["Sources/MyPage/**"],
      dependencies: [
        Module.Domain.myPage.dependency,
        Module.Domain.community.dependency,
        Module.Domain.shared.dependency,
        Module.Infrastructure.networkInterface.dependency,
        Module.Core.util.dependency,
        Module.Core.managers.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Data.login.name,
      sources: ["Sources/Login/**"],
      dependencies: [
        Module.Domain.login.dependency,
        Module.Core.dataSources.dependency,
        Module.Core.util.dependency,
        Module.Core.managers.dependency,
        Module.Infrastructure.networkInterface.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Data.alarm.name,
      sources: ["Sources/Alarm/**"],
      dependencies: [
        Module.Domain.alarm.dependency,
        Module.Infrastructure.networkInterface.dependency,
        Module.Core.util.dependency,
      ]
    ),
  ]
)
