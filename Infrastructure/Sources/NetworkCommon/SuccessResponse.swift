//
//  SuccessResponse.swift
//  Infrastructure
//
//  Created by 강동영 on 12/17/25.
//


public struct SuccessResponse<T: Decodable & Sendable>: Decodable, Sendable {
  public let success: Bool
  public let data: T
  public let message: String
}
