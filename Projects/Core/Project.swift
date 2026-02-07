import ProjectDescription
import HambugPlugin

let project = Project(
  name: Module.core.rawValue,
  targets: [
    .makeFrameworkTarget(
      name: Module.Core.designSystem.name,
      sources: ["Sources/DesignSystem/**"],
      resources: ["Sources/DesignSystem/Resources/**"]
    ),
    .makeFrameworkTarget(
      name: Module.Core.diKit.name,
      sources: ["Sources/DIKit/**"]
    ),
    .makeFrameworkTarget(
      name: Module.Core.sharedUI.name,
      sources: ["Sources/SharedUI/**"],
      dependencies: [
        Module.Core.designSystem.target,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Core.managers.name,
      sources: ["Sources/Managers/**"],
      dependencies: [
        Module.Core.dataSources.target,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.Core.dataSources.name,
      sources: ["Sources/DataSources/**"]
    ),
    .makeFrameworkTarget(
      name: Module.Core.util.name,
      sources: ["Sources/Util/**"]
    ),
    .makeFrameworkTarget(
      name: Module.Core.localizedString.name,
      sources: ["Sources/LocalizedString/**"]
    ),
  ]
)
