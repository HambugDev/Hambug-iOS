//
//  SNSProviderType.swift
//  Hambug
//
//  Created by 강동영 on 12/16/25.
//

import Foundation

/// Social network service provider type
/// This is business logic, not an API detail
public enum SNSProviderType {
  case kakao
  case apple

  public var identifier: String {
    switch self {
    case .kakao:
      return "kakao"
    case .apple:
      return "apple"
    }
  }
}
