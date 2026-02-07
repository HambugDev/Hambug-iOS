import ProjectDescription

// MARK: - Module (프로젝트 단위)

public enum Module: String, CaseIterable {
  case app            = "App"
  case domain         = "Domain"
  case data           = "Data"
  case presentation   = "Presentation"
  case core           = "Core"
  case infrastructure = "Infrastructure"
  case thirdParty     = "ThirdParty"

  public var projectPath: Path {
    .relativeToRoot("Projects/\(rawValue)")
  }
}

// MARK: - ModuleTarget 프로토콜

public protocol ModuleTarget {
  var rawValue: String { get }
  static var module: Module { get }
}

public extension ModuleTarget {
  var name: String { rawValue }

  /// 다른 프로젝트에서 참조 (cross-project)
  var dependency: TargetDependency {
    .project(target: name, path: Self.module.projectPath)
  }

  /// 같은 프로젝트 내 참조 (same-project)
  var target: TargetDependency {
    .target(name: name)
  }
}

// MARK: - 중첩 Target enum

public extension Module {
  enum Domain: String, CaseIterable, ModuleTarget {
    case shared    = "SharedDomain"
    case community = "CommunityDomain"
    case home      = "HomeDomain"
    case myPage    = "MyPageDomain"
    case login     = "LoginDomain"
    case alarm     = "AlarmDomain"

    public static let module: Module = .domain
  }

  enum Data: String, CaseIterable, ModuleTarget {
    case home      = "HomeData"
    case community = "CommunityData"
    case myPage    = "MyPageData"
    case login     = "LoginData"
    case alarm     = "AlarmData"

    public static let module: Module = .data
  }

  enum Presentation: String, CaseIterable, ModuleTarget {
    case alarm     = "AlarmPresentation"
    case community = "CommunityPresentation"
    case home      = "HomePresentation"
    case myPage    = "MyPagePresentation"
    case login     = "LoginPresentation"
    case intro     = "IntroPresentation"

    public static let module: Module = .presentation
  }

  enum Core: String, CaseIterable, ModuleTarget {
    case designSystem   = "DesignSystem"
    case diKit          = "DIKit"
    case sharedUI       = "SharedUI"
    case managers       = "Managers"
    case dataSources    = "DataSources"
    case util           = "Util"
    case localizedString = "LocalizedString"

    public static let module: Module = .core
  }

  enum Infrastructure: String, CaseIterable, ModuleTarget {
    case networkInterface = "NetworkInterface"
    case networkImpl      = "NetworkImpl"

    public static let module: Module = .infrastructure
  }

  enum ThirdParty: String, CaseIterable, ModuleTarget {
    case kakaoLogin = "KakaoLogin"
    case fcmService = "FCMService"

    public static let module: Module = .thirdParty
  }
}

// MARK: - ExternalDependency (외부 SPM)

public enum ExternalDependency: String {
  case alamofire         = "Alamofire"
  case firebaseCore      = "FirebaseCore"
  case firebaseMessaging = "FirebaseMessaging"
  case firebaseAnalytics = "FirebaseAnalytics"
  case kakaoSDKCommon    = "KakaoSDKCommon"
  case kakaoSDKAuth      = "KakaoSDKAuth"
  case kakaoSDKUser      = "KakaoSDKUser"

  public var dependency: TargetDependency {
    .external(name: rawValue)
  }
}
