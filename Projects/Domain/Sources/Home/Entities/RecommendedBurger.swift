//
//  RecommendedBurger.swift
//  HomeDomain
//
//  Created by 강동영 on 1/5/26.
//

import Foundation

public struct RecommendedBurger: Identifiable, Equatable, Sendable {
  public let id: Int
  public let menuImage: String
  public let franchise: String
  public let menuName: String
  public let menuDescription: String

  public init(id: Int, menuImage: String, franchise: String,
              menuName: String, menuDescription: String) {
    self.id = id
    self.menuImage = menuImage
    self.franchise = franchise
    self.menuName = menuName
    self.menuDescription = menuDescription
  }
}

// MARK: - Sample Data
extension RecommendedBurger {
  public static var sampleData: [RecommendedBurger] {
    return [
      RecommendedBurger(
        id: 1,
        menuImage: "https://via.placeholder.com/300",
        franchise: "맥도날드",
        menuName: "빅맥",
        menuDescription: "클래식한 맛의 대표 버거"
      ),
      RecommendedBurger(
        id: 2,
        menuImage: "https://via.placeholder.com/300",
        franchise: "버거킹",
        menuName: "와퍼",
        menuDescription: "불맛 가득한 프리미엄 버거"
      ),
      RecommendedBurger(
        id: 3,
        menuImage: "https://via.placeholder.com/300",
        franchise: "쉑쉑버거",
        menuName: "쉑버거",
        menuDescription: "수제 스타일의 신선한 버거"
      )
    ]
  }
}
