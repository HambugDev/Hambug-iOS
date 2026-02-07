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
  name: "App",
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
        .project(target: "SharedDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "HomeDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "CommunityDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "MyPageDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "LoginDomain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "AlarmDomain", path: .relativeToRoot("Projects/Domain")),

        // Data
        .project(target: "HomeData", path: .relativeToRoot("Projects/Data")),
        .project(target: "CommunityData", path: .relativeToRoot("Projects/Data")),
        .project(target: "MyPageData", path: .relativeToRoot("Projects/Data")),
        .project(target: "LoginData", path: .relativeToRoot("Projects/Data")),
        .project(target: "AlarmData", path: .relativeToRoot("Projects/Data")),

        // Presentation
        .project(target: "HomePresentation", path: .relativeToRoot("Projects/Presentation")),
        .project(target: "CommunityPresentation", path: .relativeToRoot("Projects/Presentation")),
        .project(target: "MyPagePresentation", path: .relativeToRoot("Projects/Presentation")),
        .project(target: "LoginPresentation", path: .relativeToRoot("Projects/Presentation")),
        .project(target: "AlarmPresentation", path: .relativeToRoot("Projects/Presentation")),
        .project(target: "IntroPresentation", path: .relativeToRoot("Projects/Presentation")),

        // Core
        .project(target: "DIKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/Core")),
        .project(target: "SharedUI", path: .relativeToRoot("Projects/Core")),
        .project(target: "Managers", path: .relativeToRoot("Projects/Core")),
        .project(target: "DataSources", path: .relativeToRoot("Projects/Core")),
        .project(target: "Util", path: .relativeToRoot("Projects/Core")),

        // Infrastructure
        .project(target: "NetworkInterface", path: .relativeToRoot("Projects/Infrastructure")),
        .project(target: "NetworkImpl", path: .relativeToRoot("Projects/Infrastructure")),

        // ThirdParty
        .project(target: "KakaoLogin", path: .relativeToRoot("Projects/ThirdParty")),
        .project(target: "FCMService", path: .relativeToRoot("Projects/ThirdParty")),
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
  ]
)
