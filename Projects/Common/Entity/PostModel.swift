//
//  PopularPostModel.swift
//  Hambug
//
//  Created by 차상진 on 9/6/25.
//

import SwiftUI

struct PostCodableItem: Codable {
    var id: Int64
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
}


struct PostModel: Identifiable {
    var postCodableItem: PostCodableItem
    
    init(postCodableItem: PostCodableItem) {
        self.postCodableItem = postCodableItem
    }
    
    let dateFormatter = DateFormatter()
    
    var id: Int64 {
        postCodableItem.id
    }
    
    var title: String {
        postCodableItem.title
    }
    
    var content: String {
        postCodableItem.content
    }
    
    var time: String {
        dateFormatting(format: "hh:mm")
    }
    
    var date: String {
        dateFormatting(format: "MM.dd")
    }
    
    
    
    func dateFormatting(format: String) -> String {
        dateFormatter.dateFormat = format
        switch postCodableItem.createdAt.compare(postCodableItem.updatedAt) {
            
        case .orderedSame:
            print("createdAt == updatedAt")
            return dateFormatter.string(from: postCodableItem.createdAt)
            
        case .orderedDescending:
            print("createdAt < updatedAt")
            return dateFormatter.string(from: postCodableItem.updatedAt)
            
        case .orderedAscending:
            print("createdAt > updatedAt")
            return dateFormatter.string(from: postCodableItem.updatedAt)
        }
    }
    
}
