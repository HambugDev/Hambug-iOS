//
//  HambugKeychainKey.swift
//  Common
//
//  Created by 강동영 on 1/13/26.
//

import Foundation

// MARK: - Supporting Types

public enum HambugKeychainKey {
  public static let serviceID = Bundle.main.bundleIdentifier ?? "com.hambug"

  case accessToken
  case refreshToken
  case fcmToken

  var toString: String {
    switch self {
    case .accessToken: return "access_token"
    case .refreshToken: return "refresh_token"
    case .fcmToken: return "fcm_token"
    }
  }
}
