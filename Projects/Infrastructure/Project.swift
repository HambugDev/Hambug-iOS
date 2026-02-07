import ProjectDescription
import HambugPlugin

let project = Project(
  name: Module.infrastructure.rawValue,
  targets: [
    .makeFrameworkTarget(
      name: Module.Infrastructure.networkInterface.name,
      sources: ["Sources/NetworkInterface/**"]
    ),
    .makeFrameworkTarget(
      name: Module.Infrastructure.networkImpl.name,
      sources: ["Sources/NetworkImpl/**"],
      dependencies: [
        Module.Infrastructure.networkInterface.target,
        Module.Core.dataSources.dependency,
        Module.Core.util.dependency,
        ExternalDependency.alamofire.dependency,
      ]
    ),
  ]
)
