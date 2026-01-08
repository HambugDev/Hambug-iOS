//
//  AuthInterceptor.swift
//  Hambug
//
//  Created by 강동영 on 12/16/25.
//


import Foundation
import DataSources
import NetworkInterface

import Alamofire

// MARK: - Auth Interceptor
public final class AuthInterceptor: RequestInterceptor {
  private let authorizationKey = "Authorization"
  private let refreshTokenKey = "Authorization"
  private let maxRetryCount = 1

  private let tokenManager: TokenStorage
  private let session: Session

  public init(tokenManager: TokenStorage) {
    self.tokenManager = tokenManager
    self.session = Session()
  }
  
  private actor RefreshCoordinator {
    private var refreshTask: Task<Bool, Never>?
    
    func refresh(with refreshTokens: @escaping @Sendable () async -> Bool) async -> Bool {
      if let existingTask = refreshTask {
        return await existingTask.value
      }
      
      let task = Task { @MainActor in
        await refreshTokens()
      }
      
      refreshTask = task
      let result = await task.value
      refreshTask = nil
      
      return result
    }
    
  }
  
  private let coordinator = RefreshCoordinator()
  
  public func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    var urlRequest = urlRequest
    
    let (access, refresh) = tokenManager.load()
    print(#function)
    
    print("🔑 access: \(access ?? "")")
    print("🔑 refresh: \(refresh ?? "")")
    
    if let accessToken = access {
      urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: authorizationKey)
    }
    
    completion(.success(urlRequest))
  }
  
  public func retry(
    _ request: Request,
    for session: Session,
    dueTo error: any Error,
    completion: @escaping @Sendable (RetryResult) -> Void
  ) {
    print(#function)
    guard let response = request.task?.response as? HTTPURLResponse,
          response.statusCode == 403 else {
      completion(.doNotRetryWithError(error))
      return
    }

    guard request.retryCount < maxRetryCount else {
      print("⚠️ Max retry count reached. Logging out.")
      completion(.doNotRetry)
      handleLogout()
      return
    }

    Task { @MainActor in
      let success = await coordinator.refresh { [weak self] in
        guard let self = self else { return false }
        return await self.refreshTokens()
      }

      print("retry is success?: \(success)")
      if success {
        completion(.retry)
      } else {
        completion(.doNotRetry)
        handleLogout()
      }
    }

  }
  
  private func refreshTokens() async -> Bool {
    let tokens = tokenManager.load()
    guard let refreshToken = tokens.refreshToken else {
      return false
    }
    
    var header = [String : String]()
    header[refreshTokenKey] = "Bearer \(refreshToken)"
    
    guard let request = try? TokenRefreshEndpoint(headers: header).createURLRequest() else {
      return false
    }
    
    do {
      let tokenResponse = try await session.request(request)
        .validate()
        .serializingDecodable(SuccessResponse<String>.self)
        .value
      
      try? tokenManager.save(accessToken: tokenResponse.data, refreshToken: nil)
      
      return true
    } catch {
      return false
    }
  }
  
  private func handleLogout() {
    try? tokenManager.clear()
    NotificationCenter.default.post(name: .userDidLogout, object: nil)
  }
  
}

public extension NSNotification.Name {
  static let userDidLogout = NSNotification.Name("userDidLogout")
}
