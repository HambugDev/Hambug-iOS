//
//  KeychainTokenStorage.swift
//  Hambug
//
//  Created by 강동영 on 12/11/25.
//

import Foundation

public protocol TokenStorage {
  func save(_ token: String, key: HambugKeychainKey) throws
  func load(_ key: HambugKeychainKey) -> String?
  func clear(_ key: HambugKeychainKey) throws
  func exists(_ key: HambugKeychainKey) throws -> Bool
}

public class KeychainTokenStorage: TokenStorage {
  private let service: String

  public init(service: String = HambugKeychainKey.serviceID) {
    self.service = service
  }
  
  public func save(_ token: String, key: HambugKeychainKey) throws {
    try set(token, for: key)
  }
  
  public func load(_ key: HambugKeychainKey) -> String? {
    try? string(for: key)
  }
  
  public func clear(_ key: HambugKeychainKey) throws {
    try delete(key)
  }
  
  public func exists(_ key: HambugKeychainKey) throws -> Bool {
    try contains(key)
  }
}

extension KeychainTokenStorage {
  
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
