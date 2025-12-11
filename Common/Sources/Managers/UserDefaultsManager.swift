//
//  UserDefaultsManager.swift
//  Common
//
//  Created by 강동영 on 12/5/25.
//

import Foundation

@propertyWrapper
struct UDDefaultWrapper<T> {
  private let ud = UserDefaults.standard
  var key: String
  var defaultValue: T
  var wrappedValue: T {
    get {
      return ud.value(forKey: key) as? T ?? defaultValue
    }
    set {
      ud.setValue(newValue, forKey: key)
      ud.synchronize()
    }
  }
}

public struct UserDefaultsManager {
  public static let shared = UserDefaultsManager()
  @UDDefaultWrapper(key: .Storage.hasSeenOnboarding, defaultValue: false)
  var isOnboardingCompleted: Bool
}
