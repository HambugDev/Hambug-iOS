//
//  EndPointEncoder.swift
//  Infrastructure
//
//  Created by 강동영 on 1/9/26.
//

import Foundation

public protocol EndPointEncoder {
  func encode(_ value: Encodable) -> [String: Any]
}

public struct DefaultQueryEncoder: EndPointEncoder {
  public init() {}
  public func encode(_ value: Encodable) -> [String: Any] {
    let encoder = JSONEncoder()
    guard
      let data = try? encoder.encode(value),
      let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else { return [:] }
    
    return object
  }
}
