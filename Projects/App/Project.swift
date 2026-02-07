import ProjectDescription
import HambugPlugin

let infoPlist: [String: Plist.Value] = [
  "CFBundleDisplayName": "햄버그",
  "CFBundleURLTypes": [
    [
      "CFBundleTypeRole": "Editor",
      "CFBundleURLSchemes": ["kakao$(KAKAO_NATIVE_APP_KEY)"],
    ],
  ],
  "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
  "BASE_URL": "$(BASE_URL)",
  "UIUserInterfaceStyle": "Light",
  "LSApplicationQueriesSchemes": [
    "kakaokompassauth",
    "kakaolink",
    "kakaoplus",
    "kakaotalk",
  ],
  "FirebaseMessagingAutoInitEnabled": true,
  "FirebaseAppDelegateProxyEnabled": false,
  "UILaunchScreen": [:],
]

let project = Project(
  name: Module.app.rawValue,
  targets: [
    .target(
      name: "Hambug",
      destinations: HambugConfig.destinations,
      product: .app,
      bundleId: "com.hambug",
      deploymentTargets: HambugConfig.deploymentTargets,
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["Sources/**"],
      resources: [
        "Resources/**",
      ],
      entitlements: .file(path: "Hambug.entitlements"),
      dependencies: [
        // Domain
        Module.Domain.shared.dependency,
        Module.Domain.home.dependency,
        Module.Domain.community.dependency,
        Module.Domain.myPage.dependency,
        Module.Domain.login.dependency,
        Module.Domain.alarm.dependency,

        // Data
        Module.Data.home.dependency,
        Module.Data.community.dependency,
        Module.Data.myPage.dependency,
        Module.Data.login.dependency,
        Module.Data.alarm.dependency,

        // Presentation
        Module.Presentation.home.dependency,
        Module.Presentation.community.dependency,
        Module.Presentation.myPage.dependency,
        Module.Presentation.login.dependency,
        Module.Presentation.alarm.dependency,
        Module.Presentation.intro.dependency,

        // Core
        Module.Core.diKit.dependency,
        Module.Core.designSystem.dependency,
        Module.Core.sharedUI.dependency,
        Module.Core.managers.dependency,
        Module.Core.dataSources.dependency,
        Module.Core.util.dependency,

        // Infrastructure
        Module.Infrastructure.networkInterface.dependency,
        Module.Infrastructure.networkImpl.dependency,

        // ThirdParty
        Module.ThirdParty.kakaoLogin.dependency,
        Module.ThirdParty.fcmService.dependency,
      ],
      settings: .settings(
        base: [
          "SWIFT_VERSION": "\(HambugConfig.swiftVersion)",
          "DEVELOPMENT_TEAM": "FL4QTRRKMD",
        ],
        configurations: [
          .debug(name: "Debug", xcconfig: .relativeToRoot("Common.xcconfig")),
          .release(name: "Release", xcconfig: .relativeToRoot("Common.xcconfig")),
        ]
      )
    ),
    .makeUITestTarget(
      name: "Hambug",
      sources: ["Tests/HambugUITests/**"]
    )
  ]
)
