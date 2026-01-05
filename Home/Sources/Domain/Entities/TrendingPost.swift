//
//  TrendingPost.swift
//  HomeDomain
//
//  Created by Claude on 1/5/26.
//

import Foundation

public struct TrendingPost: Identifiable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let content: String
    public let category: String
    public let imageUrls: [String]
    public let authorNickname: String
    public let authorId: Int
    public let createdAt: Date
    public let updatedAt: Date
    public let viewCount: Int
    public let likeCount: Int
    public let commentCount: Int
    public let isLiked: Bool

    // UI 표시용 계산 프로퍼티
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter.string(from: createdAt)
    }

    public var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: createdAt)
    }

    public init(id: Int, title: String, content: String, category: String,
                imageUrls: [String], authorNickname: String, authorId: Int,
                createdAt: Date, updatedAt: Date, viewCount: Int,
                likeCount: Int, commentCount: Int, isLiked: Bool) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.imageUrls = imageUrls
        self.authorNickname = authorNickname
        self.authorId = authorId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.isLiked = isLiked
    }
}
