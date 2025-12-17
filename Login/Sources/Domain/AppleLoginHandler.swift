//
//  AppleLoginHandler.swift
//  Hambug
//
//  Created by Claude on 12/16/25.
//

import Foundation
import AuthenticationServices

/// Handler for Apple Sign-In callbacks
/// Moved to Domain because LoginUseCase protocol references it
public struct AppleLoginHandler {
  public var onRequest: @Sendable (ASAuthorizationAppleIDRequest) -> Void
  public var onCompletion: @Sendable (Result<ASAuthorization, Error>) -> Void

  public init(
    onRequest: @escaping @Sendable (ASAuthorizationAppleIDRequest) -> Void,
    onCompletion: @escaping @Sendable (Result<ASAuthorization, Error>) -> Void
  ) {
    self.onRequest = onRequest
    self.onCompletion = onCompletion
  }
}
