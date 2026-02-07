//
//  PopularPostModel.swift
//  Hambug
//
//  Created by 차상진 on 9/6/25.
//

import Foundation

public struct PostCodableItem: Codable {
    public var id: Int64
    public var title: String
    public var content: String
    public var createdAt: Date
    public var updatedAt: Date

    public init(id: Int64, title: String, content: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


public struct PostModel: Identifiable {
    public var postCodableItem: PostCodableItem

    public init(postCodableItem: PostCodableItem) {
        self.postCodableItem = postCodableItem
    }
    
    let dateFormatter = DateFormatter()

    public var id: Int64 {
        postCodableItem.id
    }

    public var title: String {
        postCodableItem.title
    }

    public var content: String {
        postCodableItem.content
    }

    public var time: String {
        dateFormatting(format: "hh:mm")
    }

    public var date: String {
        dateFormatting(format: "MM.dd")
    }



    public func dateFormatting(format: String) -> String {
        dateFormatter.dateFormat = format
        switch postCodableItem.createdAt.compare(postCodableItem.updatedAt) {
            
        case .orderedSame:
            return dateFormatter.string(from: postCodableItem.createdAt)
            
        case .orderedDescending:
            return dateFormatter.string(from: postCodableItem.updatedAt)
            
        case .orderedAscending:
            return dateFormatter.string(from: postCodableItem.updatedAt)
        }
    }
    
}
