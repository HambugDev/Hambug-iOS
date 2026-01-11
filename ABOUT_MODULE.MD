# Hambug iOS - 모듈 구조

> SPM 기반 모듈러 아키텍처 상세 가이드

## 목차
- [전체 모듈 구조](#전체-모듈-구조)
- [Common 모듈](#common-모듈)
- [Infrastructure 모듈](#infrastructure-모듈)
- [기능 모듈](#기능-모듈)
- [DI 모듈](#di-모듈)
- [모듈 의존성 규칙](#모듈-의존성-규칙)
- [새 모듈 생성 가이드](#새-모듈-생성-가이드)

---

## 전체 모듈 구조

```
Hambug-iOS/
├── Hambug/                    # 메인 앱 (호스트)
│   ├── HambugApp.swift        # 앱 진입점
│   ├── RootView.swift         # 상태 기반 루트 네비게이션
│   └── ContentView.swift      # 메인 탭 뷰
│
├── Common/                    # 공통 모듈 (모든 모듈이 의존 가능)
│   ├── Managers               # 앱 상태, 유틸리티 매니저
│   ├── DesignSystem           # 색상, 폰트, 타이포그래피
│   ├── DataSources            # Keychain, UserDefaults
│   ├── LocalizedString        # 로컬라이제이션
│   ├── Util                   # 공통 유틸리티, Extension
│   └── SharedUI               # 공유 UI 컴포넌트
│
├── Infrastructure/            # 인프라 레이어
│   ├── NetworkInterface/      # 네트워크 프로토콜 정의
│   └── NetworkImpl/           # Alamofire 기반 구현체
│
├── Home/                      # 홈 기능 모듈
├── Community/                 # 커뮤니티 기능 모듈
├── MyPage/                    # 마이페이지 기능 모듈
├── Login/                     # 로그인 기능 모듈
├── Intro/                     # 온보딩/스플래시
│
├── 3rdParty/                  # 서드파티 SDK 래퍼
│   └── KakaoLogin             # Kakao SDK 래퍼
│
└── DI/                        # 의존성 주입 컨테이너
    ├── DIKit                  # Generic DI Container
    ├── AppDI                  # 앱 레벨 DI
    ├── IntroDI
    ├── LoginDI
    ├── HomeDI
    ├── CommunityDI
    └── MyPageDI
```

### 의존성 그래프

```
                    Hambug (Main App)
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
      Home            Community          MyPage
        │                 │                 │
        └─────────────────┼─────────────────┘
                          ▼
                    DI (DIKit + AppDI)
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
  Infrastructure       Common           3rdParty
  (NetworkInterface)   (모든 공통)      (KakaoLogin)
        │
        ▼
  NetworkImpl
  (Alamofire)
```

---

## Common 모듈

**위치**: `/Common/`

**역할**: 모든 모듈에서 공통으로 사용하는 유틸리티, UI 컴포넌트, 디자인 시스템

### Package.swift

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "Common",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "Managers", targets: ["Managers"]),
    .library(name: "DesignSystem", targets: ["DesignSystem"]),
    .library(name: "DataSources", targets: ["DataSources"]),
    .library(name: "LocalizedString", targets: ["LocalizedString"]),
    .library(name: "Util", targets: ["Util"]),
    .library(name: "SharedUI", targets: ["SharedUI"]),
  ],
  dependencies: [
    // KeychainAccess for secure storage
  ],
  targets: [
    .target(name: "Managers", dependencies: []),
    .target(name: "DesignSystem", resources: [.process("Resources")]),
    .target(name: "DataSources", dependencies: ["KeychainAccess"]),
    .target(name: "LocalizedString", dependencies: []),
    .target(name: "Util", dependencies: []),
    .target(name: "SharedUI", dependencies: ["DesignSystem"]),
  ]
)
```

### 주요 컴포넌트

#### Managers
- `AppStateManager`: 앱 상태 관리 (splash → onboarding → login → main)
- `UserDefaultsManager`: UserDefaults 래퍼
- `FontManager`: 커스텀 폰트 관리

#### DesignSystem
- `Color.xcassets`: 브랜드 컬러
- `Font/`: 커스텀 폰트 파일
- `Typography.swift`: 타이포그래피 정의
- `View+Keyboard.swift`: 키보드 관련 extension

#### DataSources
- `KeychainTokenStorage`: 토큰 저장 (Keychain)
- `TokenStorage` protocol

#### SharedUI
- `CustomTabView/`: 커스텀 탭 바 컴포넌트
- `HambugTab`: 탭 정의
- `TabBarVisibilityKey`: 탭 바 숨김/표시 environment key

#### Util
- `Combine+Ext.swift`: Publisher → async/await 브릿지
- 기타 공통 extension

**의존성**: 없음 (최하위 레이어)

---

## Infrastructure 모듈

**위치**: `/Infrastructure/`

**역할**: 네트워크 레이어 추상화

### Package.swift

```swift
let package = Package(
  name: "Infrastructure",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "NetworkInterface", targets: ["NetworkInterface"]),
    .library(name: "NetworkImpl", targets: ["NetworkImpl"]),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
  ],
  targets: [
    .target(name: "NetworkInterface", dependencies: ["Common"]),
    .target(name: "NetworkImpl", dependencies: ["NetworkInterface", "Alamofire"]),
  ]
)
```

### 구조

```
Infrastructure/
└── Sources/
    ├── NetworkInterface/
    │   ├── NetworkServiceInterface.swift     (프로토콜)
    │   ├── Endpoint.swift                    (요청 추상화)
    │   ├── NetworkError.swift
    │   ├── NetworkConfig.swift
    │   └── Responses/
    │       ├── SuccessResponse.swift
    │       └── EmptyResponse.swift
    └── NetworkImpl/
        ├── NetworkServiceImpl.swift          (Alamofire 구현)
        ├── AuthInterceptor.swift             (토큰 관리)
        ├── TokenRefreshEndpoint.swift
        └── NetworkLogger.swift               (DEBUG only)
```

### 핵심 컴포넌트

#### NetworkServiceInterface
```swift
public protocol NetworkServiceInterface: Sendable {
  func request<T: Decodable>(_ endpoint: any Endpoint, responseType: T.Type)
    -> AnyPublisher<T, NetworkError>

  func uploadMultipart<T: Decodable>(
    _ endpoint: any Endpoint,
    images: [UIImage],
    responseType: T.Type
  ) -> AnyPublisher<T, NetworkError>
}
```

#### Endpoint Protocol
```swift
public protocol Endpoint: Sendable {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var queryParameters: [String: Any] { get }
  var body: Data? { get }
}
```

**의존성**: Common (DataSources, Managers)

---

## 기능 모듈

각 기능 모듈은 Clean Architecture의 3개 레이어로 구성됩니다.

### 표준 구조

```
<Feature>/
├── Package.swift
└── Sources/
    ├── <Feature>DI/
    │   └── <Feature>DIContainer.swift
    ├── <Feature>Domain/
    │   ├── Entities/
    │   ├── Repositories/          (프로토콜)
    │   ├── UseCases/
    │   └── Errors/
    ├── <Feature>Data/
    │   ├── Repositories/          (구현체)
    │   ├── API/
    │   └── DTO/
    └── <Feature>Presentation/
        ├── <Feature>View.swift
        ├── <Feature>ViewModel.swift
        └── Subviews/
```

### Home 모듈

**위치**: `/Home/`

**역할**: 홈 화면 (추천 버거, 인기 게시글)

#### Package.swift
```swift
let package = Package(
  name: "Home",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "HomeDomain", targets: ["HomeDomain"]),
    .library(name: "HomeData", targets: ["HomeData"]),
    .library(name: "HomePresentation", targets: ["HomePresentation"]),
    .library(name: "HomeDI", targets: ["HomeDI"]),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "DI", path: "../DI"),
  ],
  targets: [
    .target(name: "HomeDomain", dependencies: []),
    .target(name: "HomeData", dependencies: ["HomeDomain", "NetworkInterface"]),
    .target(name: "HomePresentation", dependencies: ["HomeDomain", "DesignSystem", "SharedUI"]),
    .target(name: "HomeDI", dependencies: ["HomeDomain", "HomeData", "HomePresentation", "DIKit"]),
  ]
)
```

**주요 파일**:
- Domain: `RecommendedBurger.swift`, `TrendingPost.swift`, `HomeUseCase.swift`
- Data: `HomeViewRepositoryImpl.swift`, `HomeAPI.swift`
- Presentation: `HomeView.swift`, `HomeViewModel.swift`

### Community 모듈

**위치**: `/Community/`

**역할**: 커뮤니티 게시판 (목록, 상세, 작성, 댓글, 좋아요, 신고)

#### Package.swift
```swift
let package = Package(
  name: "Community",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "CommunityDomain", targets: ["CommunityDomain"]),
    .library(name: "CommunityData", targets: ["CommunityData"]),
    .library(name: "CommunityPresentation", targets: ["CommunityPresentation"]),
    .library(name: "CommunityDI", targets: ["CommunityDI"]),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "DI", path: "../DI"),
  ],
  targets: [
    .target(name: "CommunityDomain", dependencies: []),
    .target(name: "CommunityData", dependencies: ["CommunityDomain", "NetworkInterface"]),
    .target(name: "CommunityPresentation", dependencies: ["CommunityDomain", "DesignSystem", "SharedUI", "Util"]),
    .target(name: "CommunityDI", dependencies: ["CommunityDomain", "CommunityData", "CommunityPresentation", "DIKit"]),
  ]
)
```

**주요 파일**:
- Domain: `Board.swift`, `Comment.swift`, `Like.swift`, `Report.swift`, `GetBoardsUseCase.swift`, `CommentUseCase.swift`
- Data: `CommunityRepositoryImpl.swift`, `CommunityAPIClient.swift`, `BoardResponse.swift`
- Presentation: `CommunityView.swift`, `CommunityDetailView.swift`, `CommunityWriteView.swift`

**특징**:
- 페이지네이션 지원 (`BoardListData`)
- Multipart 업로드 (이미지)
- Factory 패턴 (하위 ViewModel 생성)

### MyPage 모듈

**위치**: `/MyPage/`

**역할**: 사용자 프로필 및 설정

(구조는 Home/Community와 동일)

### Login 모듈

**위치**: `/Login/`

**역할**: 로그인/회원가입 (Kakao 로그인)

**특징**:
- 3rdParty (KakaoLogin) 의존

### Intro 모듈

**위치**: `/Intro/`

**역할**: 온보딩 및 스플래시 화면

**특징**:
- Domain/Data 레이어 없음 (순수 Presentation)
- 2개 product: `Onboarding`, `Splash`

```swift
let package = Package(
  name: "Intro",
  products: [
    .library(name: "Onboarding", targets: ["Onboarding"]),
    .library(name: "Splash", targets: ["Splash"]),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
  ],
  targets: [
    .target(name: "Onboarding", dependencies: ["DesignSystem", "Managers"]),
    .target(name: "Splash", dependencies: ["DesignSystem", "Managers"]),
  ]
)
```

---

## DI 모듈

**위치**: `/DI/`

**역할**: 의존성 주입 컨테이너

### Package.swift

```swift
let package = Package(
  name: "DI",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "DIKit", targets: ["DIKit"]),
    .library(name: "AppDI", targets: ["AppDI"]),
    .library(name: "IntroDI", targets: ["IntroDI"]),
    .library(name: "LoginDI", targets: ["LoginDI"]),
    .library(name: "HomeDI", targets: ["HomeDI"]),
    .library(name: "MyPageDI", targets: ["MyPageDI"]),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
  ],
  targets: [
    .target(name: "DIKit", dependencies: []),
    .target(name: "AppDI", dependencies: ["DIKit", "Common", "NetworkImpl"]),
    .target(name: "IntroDI", dependencies: ["DIKit", "AppDI"]),
    // 각 기능별 DI도 동일한 구조
  ]
)
```

### 구조

```
DI/
└── Sources/
    ├── DIKit/
    │   ├── DIContainer.swift
    │   ├── DIContainer+Assembly.swift
    │   └── Assembly.swift
    ├── AppDI/
    │   └── AppDIContainer.swift
    ├── IntroDI/
    │   └── IntroDIContainer.swift
    ├── LoginDI/
    ├── HomeDI/
    ├── MyPageDI/
    └── CommunityDI/
```

**특징**:
- DIKit: Generic DI Container (재사용 가능)
- AppDI: 앱 레벨 싱글톤 서비스 등록
- 각 기능 DI: AppDI를 부모로 하는 자식 컨테이너

---

## 모듈 의존성 규칙

### ✅ 허용

```
기능 모듈 (Home, Community, ...) → Common
기능 모듈 Data 레이어 → Infrastructure
기능 모듈 → DI
모든 모듈 → Common
```

### ❌ 금지

```
Common → 기능 모듈 (순환 의존성)
기능 모듈 → 다른 기능 모듈 (기능 간 직접 의존)
Domain 레이어 → Infrastructure (레이어 역전)
Presentation → Data (레이어 건너뛰기)
```

### 의존성 방향

```
상위 (구체적)
    ↓
  기능 모듈
    ↓
Infrastructure / DI
    ↓
  Common
    ↓
하위 (추상적)
```

### 레이어 간 의존성

```
Presentation → Domain ← Data
     ↓                     ↓
  DesignSystem      Infrastructure
     ↓                     ↓
        Common (Util)
```

---

## 새 모듈 생성 가이드

### 1. 디렉토리 생성

```bash
mkdir MyNewFeature
cd MyNewFeature
mkdir -p Sources/MyNewFeatureDomain/{Entities,Repositories,UseCases,Errors}
mkdir -p Sources/MyNewFeatureData/{Repositories,API,DTO}
mkdir -p Sources/MyNewFeaturePresentation
mkdir -p Sources/MyNewFeatureDI
```

### 2. Package.swift 작성

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "MyNewFeature",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "MyNewFeatureDomain", targets: ["MyNewFeatureDomain"]),
    .library(name: "MyNewFeatureData", targets: ["MyNewFeatureData"]),
    .library(name: "MyNewFeaturePresentation", targets: ["MyNewFeaturePresentation"]),
    .library(name: "MyNewFeatureDI", targets: ["MyNewFeatureDI"]),
  ],
  dependencies: [
    .package(name: "Common", path: "../Common"),
    .package(name: "Infrastructure", path: "../Infrastructure"),
    .package(name: "DI", path: "../DI"),
  ],
  targets: [
    // Domain: 의존성 없음
    .target(
      name: "MyNewFeatureDomain",
      dependencies: []
    ),

    // Data: Domain + Infrastructure
    .target(
      name: "MyNewFeatureData",
      dependencies: [
        "MyNewFeatureDomain",
        .product(name: "NetworkInterface", package: "Infrastructure"),
      ]
    ),

    // Presentation: Domain + Common
    .target(
      name: "MyNewFeaturePresentation",
      dependencies: [
        "MyNewFeatureDomain",
        .product(name: "DesignSystem", package: "Common"),
        .product(name: "SharedUI", package: "Common"),
        .product(name: "Util", package: "Common"),
      ]
    ),

    // DI: 모든 레이어 + DIKit
    .target(
      name: "MyNewFeatureDI",
      dependencies: [
        "MyNewFeatureDomain",
        "MyNewFeatureData",
        "MyNewFeaturePresentation",
        .product(name: "DIKit", package: "DI"),
        .product(name: "AppDI", package: "DI"),
      ]
    ),
  ]
)
```

### 3. DIContainer 생성

```swift
// Sources/MyNewFeatureDI/MyNewFeatureDIContainer.swift

import DIKit
import AppDI
import MyNewFeatureDomain
import MyNewFeatureData
import MyNewFeaturePresentation
import NetworkInterface

struct MyNewFeatureAssembly: Assembly {
  func assemble(container: GenericDIContainer) {
    // API Client
    container.register(MyNewFeatureAPIClientInterface.self) { resolver in
      MyNewFeatureAPIClient(networkService: resolver.resolve(NetworkServiceInterface.self))
    }

    // Repository
    container.register(MyNewFeatureRepository.self) { resolver in
      MyNewFeatureRepositoryImpl(apiClient: resolver.resolve(MyNewFeatureAPIClientInterface.self))
    }

    // UseCase
    container.register(MyNewFeatureUseCase.self) { resolver in
      MyNewFeatureUseCaseImpl(repository: resolver.resolve(MyNewFeatureRepository.self))
    }

    // ViewModel
    container.register(MyNewFeatureViewModel.self) { @MainActor resolver in
      MyNewFeatureViewModel(useCase: resolver.resolve(MyNewFeatureUseCase.self))
    }
  }
}

public final class MyNewFeatureDIContainer {
  private let container: GenericDIContainer

  public init(appContainer: AppDIContainer = .shared) {
    self.container = GenericDIContainer(parent: appContainer.baseContainer)
    MyNewFeatureAssembly().assemble(container: container)
  }

  @MainActor
  public func makeViewModel() -> MyNewFeatureViewModel {
    return container.resolve(MyNewFeatureViewModel.self)
  }
}
```

### 4. Xcode 프로젝트에 추가

1. Xcode에서 `Hambug.xcodeproj` 열기
2. File > Add Package Dependencies > Add Local...
3. MyNewFeature 폴더 선택
4. Target (Hambug) > Build Phases > Link Binary With Libraries에 추가

### 5. 메인 앱에서 사용

```swift
// ContentView.swift

let myNewFeatureDI = MyNewFeatureDIContainer(appContainer: appContainer)

MyNewFeatureView(viewModel: myNewFeatureDI.makeViewModel())
```

---

## 모듈 간 통신

### ❌ 잘못된 방법 (직접 의존)

```swift
// Home 모듈에서
import CommunityDomain  // ❌ 기능 모듈 간 직접 의존 금지

func navigateToCommunity() {
  // ...
}
```

### ✅ 올바른 방법 (공통 인터페이스)

```swift
// Common/Util에 정의
public protocol Navigator {
  func navigateTo(route: AppRoute)
}

public enum AppRoute {
  case home
  case community(boardId: Int?)
  case myPage
}

// 각 모듈은 Navigator 프로토콜에만 의존
```

---

## 요약

### 핵심 원칙

1. **모듈 독립성**: 각 모듈은 독립적으로 빌드 가능
2. **의존성 역전**: 상위 레이어는 하위 레이어에만 의존
3. **순환 의존 금지**: 모듈 간 순환 참조 절대 불가
4. **Common 공유**: 공통 기능은 Common 모듈로
5. **레이어 분리**: Domain/Data/Presentation 엄격 분리

### 의존성 체크리스트

- [ ] Domain 레이어는 외부 의존성 없음 (순수 Swift)
- [ ] Data 레이어는 Infrastructure에만 의존
- [ ] Presentation은 Domain + Common에만 의존
- [ ] 기능 모듈은 다른 기능 모듈에 직접 의존하지 않음
- [ ] 순환 의존성 없음

### 참고 파일

| 모듈 | Package.swift 위치 |
|------|---------------------|
| Common | `/Common/Package.swift` |
| Infrastructure | `/Infrastructure/Package.swift` |
| Home | `/Home/Package.swift` |
| Community | `/Community/Package.swift` |
| DI | `/DI/Package.swift` |

**모듈 구조에 대한 질문이 있으면 이 문서를 참조하세요!**
