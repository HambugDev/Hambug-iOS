//
//  KeychainTokenStorage.swift
//  Hambug
//
//  Created by 강동영 on 12/11/25.
//

import Foundation

public protocol TokenStorage: Sendable {
  func save(accessToken: String, refreshToken: String?) throws
  func load() -> (accessToken: String?, refreshToken: String?)
  func clear() throws
  func exists() throws -> Bool
}

public final class KeychainTokenStorage: TokenStorage {
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

private extension KeychainTokenStorage {
  
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

// MARK: - Supporting Types

public enum HambugKeychainKey {
  public static let serviceID = Bundle.main.bundleIdentifier ?? "com.hambug"

  case accessToken
  case refreshToken

  var toString: String {
    switch self {
    case .accessToken: return "access_token"
    case .refreshToken: return "refresh_token"
    }
  }
}

public enum KeychainError: Error {
  case itemNotFound
  case duplicateItem
  case invalidData
  case unexpectedPasswordData
  case unexpected(OSStatus)
}

extension KeychainError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .itemNotFound:
      return "아이템을 찾을 수 없습니다."
    case .duplicateItem:
      return "이미 존재하는 아이템입니다."
    case .invalidData:
      return "유효하지 않은 데이터입니다."
    case .unexpectedPasswordData:
      return "예상치 못한 패스워드 데이터입니다."
    case .unexpected(let status):
      return "Keychain 에러: \(status)"
    }
  }
}

