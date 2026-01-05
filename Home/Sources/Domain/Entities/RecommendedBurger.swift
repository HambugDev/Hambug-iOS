//
//  RecommendedBurger.swift
//  HomeDomain
//
//  Created by Claude on 1/5/26.
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
