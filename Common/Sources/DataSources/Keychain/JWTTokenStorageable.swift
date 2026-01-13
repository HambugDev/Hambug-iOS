//
//  JWTTokenStorageable.swift
//  Common
//
//  Created by 강동영 on 1/13/26.
//


public protocol JWTTokenStorageable {
  func save(accessToken: String, refreshToken: String?) throws
  func load() -> (accessToken: String?, refreshToken: String?)
  func clear() throws
  func exists() throws -> Bool
}

public final class JWTokenStorage: KeychainTokenStorage, JWTTokenStorageable {
  private let service: String

  public override init(service: String = HambugKeychainKey.serviceID) {
    self.service = service
  }
  
  public func save(accessToken: String, refreshToken: String?) throws {
    try set(accessToken, for: .accessToken)

    if let refresh = refreshToken {
      try set(refresh, for: .refreshToken)
    }
  }

  public func load() -> (accessToken: String?, refreshToken: String?) {
    let access = try? string(for: .accessToken)
    let refresh = try? string(for: .refreshToken)

    return (access, refresh)
  }

  public func exists() throws -> Bool {
    try contains(.accessToken)
  }

  public func clear() throws {
    try delete(.accessToken)
    try delete(.refreshToken)
  }
}