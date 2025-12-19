//
//  LoginRepository.swift
//  Hambug
//
//  Created by 차상진 on 10/9/25.
//

import Foundation
import Alamofire
import DataSources
import LoginDomain
import NetworkInterface
import NetworkCommon

public final class LoginRepositoryImpl: LoginRepository {
  private let networkService: NetworkServiceInterface
  private let tokenStorage: TokenStorage

  public init(networkService: NetworkServiceInterface, tokenStorage: TokenStorage) {
    self.networkService = networkService
    self.tokenStorage = tokenStorage
  }

  public func login(request: SocialLoginRequest) async throws {
    // Domain model → Data DTO 변환 (Adapter 패턴)
    let dto = SocialLoginAuthRequestDTO(
      provider: request.provider.identifier,
      accessToken: request.accessToken
    )

    let endpoint = AuthEndpoint.socialLogin(request: dto)

    // NetworkService를 사용하여 API 호출
    let apiResponse: SuccessResponse<UserResponse> = try await networkService
      .request(
        endpoint,
        responseType: SuccessResponse<UserResponse>.self
      )
      .async()

    // 토큰을 Keychain에 저장
    try tokenStorage.save(
      accessToken: apiResponse.data.token.accessToken,
      refreshToken: apiResponse.data.token.refreshToken
    )
    print("✅ Tokens saved to Keychain")
    print("✅ accessToken: \(apiResponse.data.token.accessToken,)")
    print("✅ refreshToken \(apiResponse.data.token.refreshToken)")
  }
}

