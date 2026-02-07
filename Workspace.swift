import ProjectDescription
import HambugPlugin

let workspace = Workspace(
  name: "Hambug",
  projects: Module.allCases.map(\.projectPath)
)
