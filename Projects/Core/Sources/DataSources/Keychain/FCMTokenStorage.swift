//
//  FCMTokenStorage.swift
//  Common
//
//  Created by 강동영 on 1/13/26.
//


public protocol FCMTokenStorageable {
  func save(_ token: String) throws
  func load() -> String?
  func clear() throws
  func exists() throws -> Bool
}

public final class FCMTokenStorage: KeychainTokenStorage, FCMTokenStorageable {
  private let service: String

  public override init(service: String = HambugKeychainKey.serviceID) {
    self.service = service
  }
  
  public func save(_ token: String) throws {
    try set(token, for: .fcmToken)
  }
  
  public func load() -> String? {
    try? string(for: .fcmToken)
  }
  
  public func clear() throws {
    try delete(.fcmToken)
  }
  
  public func exists() throws -> Bool {
    try contains(.fcmToken)
  }
}
