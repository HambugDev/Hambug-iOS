//
//  JWTTokenStorageable.swift
//  Common
//
//  Created by 강동영 on 1/13/26.
//

import Foundation

public protocol JWTTokenStorageable: Sendable {
  func save(accessToken: String, refreshToken: String?) throws
  func load() -> (accessToken: String?, refreshToken: String?)
  func clear() throws
  func exists() throws -> Bool
}

public final class JWTokenStorage: /*KeychainTokenStorage,*/ JWTTokenStorageable {
  private let service: String

  public init(service: String = HambugKeychainKey.serviceID) {
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


extension JWTokenStorage {
  
  func set(_ value: String, for key: HambugKeychainKey) throws {
    let data = value.data(using: .utf8)!
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key.toString,
      kSecValueData as String: data
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    do {
      try handleError(status)
    } catch KeychainError.duplicateItem {
      // 중복 된 아이템이 있다면 업데이트 수행
      try updateExisting(data, for: key)
    }
  }
  
  func updateExisting(_ data: Data, for key: HambugKeychainKey) throws {
    let updateQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key.toString
    ]
    
    let attributes: [String: Any] = [
      kSecValueData as String: data
    ]
    
    let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
    
    try handleError(updateStatus)
  }
  
  func string(for key: HambugKeychainKey) throws -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key.toString,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    try handleError(status)
    
    guard let data = item as? Data,
          let string = String(data: data, encoding: .utf8)
    else {
      throw KeychainError.unexpectedPasswordData
    }
    return string
  }
  
  func delete(_ key: HambugKeychainKey) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key.toString
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    try handleError(status)
  }
  
  func contains(_ key: HambugKeychainKey) throws -> Bool {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key.toString,
    ]
    
    return SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess
  }
    
  func handleError(_ status: OSStatus) throws {
    switch status {
    case errSecSuccess:
      return
    case errSecDuplicateItem:
      throw KeychainError.duplicateItem
    case errSecItemNotFound:
      throw KeychainError.itemNotFound
    default:
      throw KeychainError.unexpected(status)
    }
  }
}

//public final class JWTokenStorage: KeychainTokenStorage, JWTTokenStorageable {
//  private let service: String
//
//  public override init(service: String = HambugKeychainKey.serviceID) {
//    self.service = service
//  }
//  
//  public func save(accessToken: String, refreshToken: String?) throws {
//    try set(accessToken, for: .accessToken)
//
//    if let refresh = refreshToken {
//      try set(refresh, for: .refreshToken)
//    }
//  }
//
//  public func load() -> (accessToken: String?, refreshToken: String?) {
//    let access = try? string(for: .accessToken)
//    let refresh = try? string(for: .refreshToken)
//
//    return (access, refresh)
//  }
//
//  public func exists() throws -> Bool {
//    try contains(.accessToken)
//  }
//
//  public func clear() throws {
//    try delete(.accessToken)
//    try delete(.refreshToken)
//  }
//}
