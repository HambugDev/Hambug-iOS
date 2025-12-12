//
//  SuccessResponse.swift
//  Hambug
//
//  Created by 강동영 on 12/12/25.
//


struct SuccessResponse<T: Decodable>: Decodable {
  let success: Bool
  let data: T
  let message: String
}