//
//  UserDefaultsManager.swift
//  Common
//
//  Created by 강동영 on 12/5/25.
//

import Foundation

// Helper protocol for optional handling
protocol OptionalProtocol {
  var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
  var isNil: Bool { self == nil }
}

@propertyWrapper
public struct UDDefaultWrapper<T> {
  private let ud = UserDefaults.standard
  let key: String
  let defaultValue: T

  public var wrappedValue: T {
    get {
      return ud.value(forKey: key) as? T ?? defaultValue
    }
    nonmutating set {
      if let optional = newValue as? (any OptionalProtocol), optional.isNil {
        ud.removeObject(forKey: key)
      } else {
        ud.setValue(newValue, forKey: key)
      }
      ud.synchronize()
    }
  }
}

// UserDefaults 자체가 thread-safe 하게 설계되어있기 때문에 @unchecked 사용
public final class UserDefaultsManager: @unchecked Sendable {
  public static let shared = UserDefaultsManager()

  private init() {}

  @UDDefaultWrapper(key: .Storage.hasSeenOnboarding, defaultValue: false)
  var isOnboardingCompleted: Bool

  @UDDefaultWrapper(key: .Storage.currentUserId, defaultValue: nil)
  public var currentUserId: Int64?
  
  func clearAll() {
    let keys: [String] = [
      .Storage.currentUserId,
      
    ]
    keys.forEach {
      UserDefaults.standard.removeObject(forKey: $0)
    }
  }
}
