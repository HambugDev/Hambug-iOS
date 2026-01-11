# Hambug iOS - 개발 가이드

> AI 어시스턴트와 개발자를 위한 핵심 패턴 및 컨벤션 가이드

## 목차
- [프로젝트 개요](#프로젝트-개요)
- [Clean Architecture](#clean-architecture)
- [Swift 6 패턴](#swift-6-패턴)
- [네이밍 컨벤션](#네이밍-컨벤션)
- [에러 처리](#에러-처리)
- [네트워크 레이어](#네트워크-레이어)
- [의존성 주입](#의존성-주입)
- [동시성 패턴](#동시성-패턴)
- [개발 가이드라인](#개발-가이드라인)
- [주요 파일 참조](#주요-파일-참조)
- [트러블슈팅](#트러블슈팅)

**📦 모듈 구조는 [ABOUT_MODULE.MD](./ABOUT_MODULE.MD) 참조**

---

## 프로젝트 개요

**Hambug**는 햄버거 애호가를 위한 커뮤니티 iOS 앱입니다.

### 기술 스택
- **UI**: SwiftUI
- **아키텍처**: SPM 모듈러 + Clean Architecture
- **동시성**: async/await (primary), Combine (network layer)
- **네트워킹**: Alamofire
- **의존성 주입**: 커스텀 DIKit
- **최소 버전**: iOS 17.0, Swift 6

### 핵심 원칙
1. **모듈화**: 기능별 SPM 모듈 분리
2. **Clean Architecture**: Domain/Data/Presentation 레이어 분리
3. **의존성 역전**: 프로토콜 기반 추상화
4. **타입 안전**: Sendable, async/await 준수

---

## Clean Architecture

각 기능 모듈은 3개 레이어로 구성:

```
<Feature>/
├── Domain/      # 순수 비즈니스 로직 (의존성 없음)
├── Data/        # Repository 구현, API, DTO
└── Presentation/# ViewModel, View
```

### 1. Domain 레이어

#### Entity 패턴
```swift
public struct Board: Identifiable, Equatable, Sendable {
  public let id: Int
  public let title: String
  public var commentCount: Int  // 가변 프로퍼티 가능

  // 도메인 로직 포함 가능
  private static func timeAgoDisplay(_ date: Date) -> String { }
}
```

**핵심**:
- `Sendable`, `Identifiable`, `Equatable` 준수
- Computed properties로 UI 로직 캡슐화
- Preview용 `sampleData` static 프로퍼티

**참조**: `Community/Sources/Domain/Entities/Board.swift`

#### Repository 프로토콜
```swift
public protocol CommunityRepository: Sendable {
  func fetchBoards(lastId: Int?, limit: Int, order: SortOrder) async throws -> BoardListData
  func createBoard(title: String, content: String, category: BoardCategory, images: [UIImage]) async throws -> Board
}
```

**핵심**:
- `Sendable` 준수
- async/await 기반
- 도메인 타입 반환 (DTO 아님)

#### UseCase 패턴
```swift
public protocol GetBoardsUseCase: Sendable {
  func execute(lastId: Int?, limit: Int, order: SortOrder) async throws -> BoardListData
}

public final class GetBoardsUseCaseImpl: GetBoardsUseCase {
  private let repository: CommunityRepository

  public func execute(...) async throws -> BoardListData {
    let data = try await repository.fetchBoards(...)
    // 비즈니스 로직 검증
    guard !data.content.isEmpty else {
      throw CommunityError.emptyBoards
    }
    return data
  }
}
```

**핵심**:
- Protocol + Implementation 패턴
- 데이터 검증 및 변환
- 도메인 에러 throw

**참조**: `Community/Sources/Domain/UseCases/GetBoardsUseCaseImpl.swift`

#### Domain Error
```swift
public enum HomeError: Error, LocalizedError {
  case networkFailure(underlying: Error)
  case emptyRecommendedBurgers
  case invalidBurgerData(reason: String)

  public var errorDescription: String? {
    switch self {
    case .networkFailure:
      return "네트워크 연결을 확인해주세요."
    case .invalidBurgerData(let reason):
      return "버거 데이터 오류: \(reason)"
    }
  }

  public var severity: ErrorSeverity {
    switch self {
    case .networkFailure: return .high
    case .emptyRecommendedBurgers: return .medium
    case .invalidBurgerData: return .low
    }
  }
}
```

**참조**: `Home/Sources/Domain/Errors/HomeError.swift`

### 2. Data 레이어

#### DTO + Mapper 패턴
```swift
public struct BoardResponseDTO: Decodable, Sendable {
  public let id: Int
  public let title: String
  public let createdAt: String  // ISO8601
}

extension BoardResponseDTO {
  func toDomain() -> Board {
    return Board(
      id: id,
      title: title,
      createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date()
    )
  }
}
```

**핵심**: DTO는 네트워크 전용, `toDomain()`으로 변환

**참조**: `Community/Sources/Data/DTO/BoardResponse.swift`

#### API Client
```swift
public protocol CommunityAPIClientInterface: Sendable {
  func fetchBoards(...) -> AnyPublisher<BoardListDataDTO, NetworkError>
}

public final class CommunityAPIClient: CommunityAPIClientInterface {
  private let networkService: NetworkServiceInterface

  public func fetchBoards(...) -> AnyPublisher<BoardListDataDTO, NetworkError> {
    return networkService.request(
      BoardEndpoint.boards(query),
      responseType: SuccessResponse<BoardListDataDTO>.self
    )
    .map(\.data)  // 래퍼 제거
    .eraseToAnyPublisher()
  }
}
```

**핵심**: Combine Publisher 반환, DTO 타입 사용

**참조**: `Community/Sources/Data/API/CommunityAPIClient.swift`

#### Repository 구현체
```swift
public final class CommunityRepositoryImpl: CommunityRepository {
  private let apiClient: CommunityAPIClientInterface

  public func fetchBoards(...) async throws -> BoardListData {
    return try await apiClient
      .fetchBoards(...)
      .map { $0.toDomain() }     // DTO → Domain
      .mapError { $0 as Error }
      .async()                   // Publisher → async/await
  }
}
```

**핵심**: `.async()` extension으로 Combine → async/await 변환

**참조**:
- Repository: `Community/Sources/Data/Repositories/CommunityRepositoryImpl.swift`
- Bridge: `Common/Sources/Util/Combine+Ext.swift`

### 3. Presentation 레이어

#### ViewModel 패턴
```swift
@Observable
@MainActor
public final class HomeViewModel {
    private let homeUseCase: HomeUseCase

    // State
    public var data: [Model] = []
    public var isLoading = false
    public var error: HomeError?

    public init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
        Task { await loadData() }
    }

    public func loadData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            data = try await homeUseCase.fetchData()
            print("✅ 데이터 로드 성공")
        } catch let error as HomeError {
            self.error = error
            data = Model.sampleData  // Fallback
            print("❌ 로드 실패: \(error.localizedDescription)")
        }
    }
}
```

**핵심**:
- `@Observable` + `@MainActor`
- `public final class`
- Task 초기화로 자동 로딩
- 에러 시 샘플 데이터 폴백
- 이모지 로그 (✅❌ℹ️⚠️)

**참조**: `Home/Sources/Presentation/HomeViewModel.swift`

#### View 패턴
```swift
public struct CommunityView: View {
  @State private var viewModel: CommunityViewModel
  private let writeFactory: CommunityWriteFactory  // Factory 패턴

  public init(viewModel: CommunityViewModel, writeFactory: CommunityWriteFactory) {
    self._viewModel = State(initialValue: viewModel)
    self.writeFactory = writeFactory
  }

  public var body: some View {
    NavigationStack {
      // ...
    }
    .refreshable {
      await viewModel.loadData()
    }
  }
}
```

**핵심**: ViewModel은 `@State`, Factory로 하위 ViewModel 생성

---

## Swift 6 패턴

### @Observable 매크로

```swift
// ✅ 최신
@Observable
@MainActor
public final class ViewModel {
  public var data: [Model] = []  // 자동 추적
}

// ❌ Deprecated
class ViewModel: ObservableObject {
  @Published var data: [Model] = []
}
```

### Sendable 프로토콜

모든 Entity, Protocol, DTO는 `Sendable` 준수:

```swift
public struct Board: Identifiable, Sendable { }
public protocol HomeUseCase: Sendable { }
public struct ResponseDTO: Decodable, Sendable { }
```

### async/await 동시성

```swift
// 기본
public func loadData() async {
    isLoading = true
    defer { isLoading = false }
    data = try await useCase.execute()
}

// 병렬
async let result1 = load1()
async let result2 = load2()
await result1
await result2

// Task 초기화
public init(useCase: UseCase) {
    Task { await loadData() }
}
```

### Combine → async/await 브릿지

**위치**: `Common/Sources/Util/Combine+Ext.swift`

```swift
public extension Publisher where Output: Sendable {
  func async() async throws -> Output {
    try await withCheckedThrowingContinuation { continuation in
      var cancellable: AnyCancellable?
      cancellable = first().sink { ... }
    }
  }
}
```

**사용**: Repository에서 `publisher.async()`

---

## 네이밍 컨벤션

### 파일명

| 타입 | 패턴 | 예시 |
|------|------|------|
| ViewModel | `<Feature>ViewModel.swift` | `HomeViewModel.swift` |
| UseCase | `<Action>UseCaseImpl.swift` | `GetBoardsUseCaseImpl.swift` |
| Repository | `<Domain>RepositoryImpl.swift` | `CommunityRepositoryImpl.swift` |
| API Client | `<Feature>APIClient.swift` | `CommunityAPIClient.swift` |
| Endpoint | `<Feature>API.swift` | `HomeAPI.swift` |
| DTO | `<Model>Response.swift` | `BoardResponse.swift` |
| Entity | `<Name>.swift` | `Board.swift` |
| Error | `<Feature>Error.swift` | `HomeError.swift` |

### 변수/함수명

```swift
// 로딩 상태
public var isLoading: Bool
public var isBurgersLoading: Bool

// 에러
public var errorMessage: String?
public var burgersError: HomeError?

// 비동기 함수
public func loadData() async
public func fetchBoards() async throws -> [Board]
public func createBoard(...) async throws -> Board
```

---

## 에러 처리

### 플로우

```
NetworkError (Infrastructure)
    ↓
DomainError (Repository 매핑)
    ↓
ViewModel catch → UI 표시 or 샘플 데이터 폴백
```

### ViewModel 에러 처리 패턴

```swift
do {
    data = try await useCase.execute()
    print("✅ 성공")
} catch let error as HomeError {
    self.error = error
    data = Model.sampleData  // Fallback
    print("❌ 실패: \(error.localizedDescription)")
} catch {
    self.error = .networkFailure(underlying: error)
    data = Model.sampleData
}
```

---

## 네트워크 레이어

### 아키텍처

```
ViewModel → UseCase → Repository → APIClient → NetworkService (Alamofire)
```

### 핵심 컴포넌트

| 컴포넌트 | 파일 |
|----------|------|
| NetworkServiceInterface | `Infrastructure/Sources/NetworkInterface/NetworkServiceInterface.swift` |
| NetworkServiceImpl | `Infrastructure/Sources/NetworkImpl/NetworkServiceImpl.swift` |
| AuthInterceptor | `Infrastructure/Sources/NetworkImpl/AuthInterceptor.swift` |
| KeychainTokenStorage | `Common/Sources/DataSources/KeychainTokenStorage.swift` |

### 요청 흐름

1. **Endpoint 정의**
```swift
public enum HomeEndpoint: Endpoint {
  case recommendedBurgers
  public var path: String { "/api/v1/burgers/recommended" }
  public var method: HTTPMethod { .GET }
}
```

2. **APIClient 호출** (Combine)
```swift
networkService.request(HomeEndpoint.recommendedBurgers, responseType: SuccessResponse<[DTO]>.self)
  .map(\.data)
```

3. **Repository 변환** (DTO → Domain + async)
```swift
try await apiClient.fetch().map { $0.toDomain() }.async()
```

4. **UseCase 검증**
```swift
let data = try await repository.fetch()
guard !data.isEmpty else { throw Error.empty }
```

5. **ViewModel 상태 업데이트**

---

## 의존성 주입

### DIKit 패턴

**위치**: `DI/Sources/DIKit/`

```swift
public protocol Assembly {
  func assemble(container: GenericDIContainer)
}

public enum Scope {
  case singleton  // 한 번 생성, 캐싱
  case transient  // 매번 새로 생성
}
```

### App DI Container

**위치**: `DI/Sources/AppDI/AppDIContainer.swift`

```swift
struct AppAssembly: Assembly {
  func assemble(container: GenericDIContainer) {
    container.register(NetworkServiceInterface.self, scope: .singleton) { resolver in
      NetworkServiceImpl(interceptor: AuthInterceptor(...))
    }
  }
}

@Observable
public final class AppDIContainer: @unchecked Sendable {
  public static let shared = AppDIContainer()
}
```

### 기능 DI Container

```swift
public final class CommunityDIContainer {
  private let container: GenericDIContainer

  public init(appContainer: AppDIContainer = .shared) {
    // 부모 컨테이너 상속
    self.container = GenericDIContainer(parent: appContainer.baseContainer)
    CommunityAssembly().assemble(container: container)
  }

  @MainActor
  public func makeViewModel() -> CommunityViewModel {
    return container.resolve(CommunityViewModel.self)
  }
}
```

**참조**: `Community/Sources/DI/CommunityDIContainer.swift`

### Factory 패턴

```swift
public protocol CommunityWriteFactory {
  func makeWriteViewModel() -> CommunityWriteViewModel
}

extension CommunityDIContainer: CommunityWriteFactory {
  public func makeWriteViewModel() -> CommunityWriteViewModel {
    return container.resolve(CommunityWriteViewModel.self)
  }
}
```

---

## 동시성 패턴

### 기본 패턴
```swift
public func loadData() async {
    isLoading = true
    defer { isLoading = false }
    data = try await useCase.execute()
}
```

### 병렬 로딩
```swift
async let result1 = load1()
async let result2 = load2()
await result1
await result2
```

### Task 취소
```swift
private var loadTask: Task<Void, Never>?

loadTask?.cancel()
loadTask = Task { await load() }
```

---

## 개발 가이드라인

### ✅ 권장 (DO)

**아키텍처**:
- ViewModel에 `@Observable` + `@MainActor`
- Entity를 `Sendable`로
- Domain에서 async/await
- Protocol + Implementation 패턴
- 도메인별 에러 enum
- 에러 시 샘플 데이터 폴백

**코드 스타일**:
- MARK 주석으로 섹션 구분
- 이모지 로그 (✅❌ℹ️⚠️)
- 한글 에러 메시지

### ❌ 금지 (DON'T)

- `@ObservedObject`, `@Published` 사용
- force-unwrapping (`!`)
- 순환 모듈 의존성
- Domain에 Presentation 로직 혼합
- 동기 네트워크 호출
- `Sendable` 요구사항 무시

---

## 주요 파일 참조

### 앱 구조
- 앱 진입점: `Hambug/HambugApp.swift`
- 루트 네비게이션: `Hambug/RootView.swift`
- 메인 콘텐츠: `Hambug/ContentView.swift`

### DI
- App DI: `DI/Sources/AppDI/AppDIContainer.swift`
- DIKit: `DI/Sources/DIKit/DIContainer+Assembly.swift`

### Network
- Interface: `Infrastructure/Sources/NetworkInterface/NetworkServiceInterface.swift`
- Implementation: `Infrastructure/Sources/NetworkImpl/NetworkServiceImpl.swift`
- Token Storage: `Common/Sources/DataSources/KeychainTokenStorage.swift`

### Common
- Combine Bridge: `Common/Sources/Util/Combine+Ext.swift`
- DesignSystem: `Common/Sources/DesignSystem/`
- CustomTabView: `Common/Sources/SharedUI/CustomTabView/CustomTabView.swift`

### 기능 모듈 예시
- Home ViewModel: `Home/Sources/Presentation/HomeViewModel.swift`
- Home Error: `Home/Sources/Domain/Errors/HomeError.swift`
- Community ViewModel: `Community/Sources/Presentation/Community/CommunityViewModel.swift`
- Board Entity: `Community/Sources/Domain/Entities/Board.swift`

---

## 트러블슈팅

### 1. Sendable 에러
```
Type '...' does not conform to protocol 'Sendable'
```

**해결**: Entity/Protocol/DTO에 `Sendable` 추가
```swift
public struct Board: Identifiable, Sendable { }
public protocol UseCase: Sendable { }
```

### 2. MainActor 에러
```
Call to main actor-isolated initializer in a synchronous context
```

**해결**: DI Container에서 `@MainActor` 명시
```swift
container.register(ViewModel.self) { @MainActor resolver in
  ViewModel(...)
}
```

### 3. @Published 에러
```
Cannot convert 'Published<...>.Publisher'
```

**해결**: `@Observable` 사용
```swift
// ❌
@Published var data: [Model]

// ✅
@Observable
class ViewModel {
  var data: [Model]
}
```

### 4. 샘플 데이터가 계속 표시됨

**확인**:
1. 콘솔 로그 (❌ 에러 메시지)
2. `error` 프로퍼티 확인
3. 네트워크 연결
4. 토큰 유효성

### 5. Module not found

**해결**:
```bash
# Xcode
File > Packages > Reset Package Caches

# 터미널
rm -rf .build
xcodebuild -resolvePackageDependencies
```

---

## 마이그레이션 노트

### ObservableObject → @Observable

**구식 (iOS 13-16)**:
```swift
class ViewModel: ObservableObject {
  @Published var data: [Model] = []
}

struct View: View {
  @ObservedObject var viewModel: ViewModel
}
```

**최신 (iOS 17+)**:
```swift
@Observable
@MainActor
final class ViewModel {
  var data: [Model] = []
}

struct View: View {
  @State private var viewModel: ViewModel
}
```

---

## 현재 개발 상태

- **활성 브랜치**: `feature/community`
- **메인 브랜치**: `develop`
- **최근 작업**: Community list/detail/write, CustomTabView, Report/Comment/Like

---

## 참고 문서

- 📦 **모듈 구조**: [ABOUT_MODULE.MD](./ABOUT_MODULE.MD)

---

## 요약

**Hambug iOS 핵심 원칙**:
1. SPM 모듈화 + Clean Architecture
2. Swift 6 (@Observable, Sendable, async/await)
3. 프로토콜 기반 추상화
4. 도메인 에러 + 샘플 데이터 폴백
5. DIKit 계층적 DI
6. async/await 우선, Combine은 네트워크만

**파일을 읽을 때는 실제 파일을 직접 읽으세요. 여기는 패턴 참조용입니다!**
