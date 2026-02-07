import ProjectDescription
import HambugPlugin

let project = Project(
  name: Module.thirdParty.rawValue,
  targets: [
    .makeFrameworkTarget(
      name: Module.ThirdParty.kakaoLogin.name,
      sources: ["Sources/KakaoLogin/**"],
      dependencies: [
        ExternalDependency.kakaoSDKCommon.dependency,
        ExternalDependency.kakaoSDKAuth.dependency,
        ExternalDependency.kakaoSDKUser.dependency,
      ]
    ),
    .makeFrameworkTarget(
      name: Module.ThirdParty.fcmService.name,
      sources: ["Sources/FCMService/**"],
      dependencies: [
        ExternalDependency.firebaseAnalytics.dependency,
        ExternalDependency.firebaseCore.dependency,
        ExternalDependency.firebaseMessaging.dependency,
        Module.Infrastructure.networkInterface.dependency,
        Module.Core.dataSources.dependency,
        Module.Core.util.dependency,
      ]
    ),
  ]
)
