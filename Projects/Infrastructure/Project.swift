import ProjectDescription
import HambugPlugin

let project = Project(
  name: "Infrastructure",
  targets: [
    .makeFrameworkTarget(
      name: "NetworkInterface",
      sources: ["Sources/NetworkInterface/**"]
    ),
    .makeFrameworkTarget(
      name: "NetworkImpl",
      sources: ["Sources/NetworkImpl/**"],
      dependencies: [
        .target(name: "NetworkInterface"),
        .project(target: "DataSources", path: .relativeToRoot("Projects/Core")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),
        .external(name: "Alamofire"),
      ]
    ),
  ]
)
