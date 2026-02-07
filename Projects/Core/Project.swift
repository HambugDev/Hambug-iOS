import ProjectDescription
import HambugPlugin

let project = Project(
  name: "Core",
  targets: [
    .makeFrameworkTarget(
      name: "DesignSystem",
      sources: ["Sources/DesignSystem/**"],
      resources: ["Sources/DesignSystem/Resources/**"]
    ),
    .makeFrameworkTarget(
      name: "DIKit",
      sources: ["Sources/DIKit/**"]
    ),
    .makeFrameworkTarget(
      name: "SharedUI",
      sources: ["Sources/SharedUI/**"],
      dependencies: [
        .target(name: "DesignSystem"),
      ]
    ),
    .makeFrameworkTarget(
      name: "Managers",
      sources: ["Sources/Managers/**"],
      dependencies: [
        .target(name: "DataSources"),
      ]
    ),
    .makeFrameworkTarget(
      name: "DataSources",
      sources: ["Sources/DataSources/**"]
    ),
    .makeFrameworkTarget(
      name: "Util",
      sources: ["Sources/Util/**"]
    ),
    .makeFrameworkTarget(
      name: "LocalizedString",
      sources: ["Sources/LocalizedString/**"]
    ),
  ]
)
