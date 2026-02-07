import ProjectDescription

let tuist = Tuist(
  compatibleXcodeVersions: .all,
  plugins: [
    .local(path: .relativeToRoot("Plugins/HambugPlugin")),
  ],
  generationOptions: .options(
    enforceExplicitDependencies: true
  )
)
