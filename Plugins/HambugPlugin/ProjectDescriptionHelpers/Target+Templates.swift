import ProjectDescription

public enum HambugConfig {
  public static let bundleIdPrefix = "com.hambug"
  public static let destinations: Destinations = .iOS
  public static let deploymentTargets: DeploymentTargets = .iOS("17.0")
  public static let swiftVersion: Version = "6.0"
}

public extension Target {
  /// Create a framework target with common settings
  static func makeFrameworkTarget(
    name: String,
    bundleId: String? = nil,
    sources: SourceFilesList,
    resources: ResourceFileElements? = nil,
    dependencies: [TargetDependency] = []
  ) -> Target {
    .target(
      name: name,
      destinations: HambugConfig.destinations,
      product: .framework,
      bundleId: bundleId ?? "\(HambugConfig.bundleIdPrefix).\(name.lowercased())",
      deploymentTargets: HambugConfig.deploymentTargets,
      sources: sources,
      resources: resources,
      dependencies: dependencies,
      settings: .settings(
        base: ["SWIFT_VERSION": "\(HambugConfig.swiftVersion)"]
      )
    )
  }
  
  /// Create a UITest target with common settings
  static func makeUITestTarget(
    name: String,
    bundleId: String? = nil,
    sources: SourceFilesList,
    resources: ResourceFileElements? = nil,
    dependencies: [TargetDependency] = []
  ) -> Target {
    .target(
      name: "\(name)UITests",
      destinations: HambugConfig.destinations,
      product: .uiTests,
      bundleId: bundleId ?? "\(HambugConfig.bundleIdPrefix).\(name.lowercased())",
      deploymentTargets: HambugConfig.deploymentTargets,
      sources: sources,
      resources: resources,
      dependencies: dependencies,
      settings: .settings(
        base: ["SWIFT_VERSION": "\(HambugConfig.swiftVersion)"]
      )
    )
  }
}
