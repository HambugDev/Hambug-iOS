//
//  Board.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation

// MARK: - Board Entity
public struct Board: Identifiable, Equatable {
  public let id: Int
  public let imageURL: String
  public let title: String
  public let nickName: String
  public let content: String
  public let createdAt: String
  public let likeCount: String
  public let commnetCount: String

  public init(id: Int, imageURL: String, title: String, nickName: String, content: String, createdAt: String, likeCount: String, commnetCount: String) {
    self.id = id
    self.imageURL = imageURL
    self.title = title
    self.nickName = nickName
    self.content = content
    self.createdAt = createdAt
    self.likeCount = likeCount
    self.commnetCount = commnetCount
  }

  // Preview용 샘플 데이터
  public static var sampleData: [Board] {
    return [Board(
      id: 1,
      imageURL: "",
      title: "다들 햄최몇인가요12345678910121231314?",
      nickName: "닉네임1",
      content: "요즘 햄버거 맛집이 어디인지 궁금해요!",
      createdAt: "1분 전",
      likeCount: "11",
      commnetCount: "10"
    )] + _sampleData
  }
  
  private static let _sampleData: [Board] = (2...18).map {
    Board(
      id: $0,
      imageURL: "",
      title: "다들 햄최몇인가요?",
      nickName: "닉네임\($0)",
      content: "간단한 내용입니다.",
      createdAt: "2분 전",
      likeCount: "\($0)\($0+1)",
      commnetCount: "\($0+1)\($0)"
    )
  }
}

// MARK: - Date Extension for Time Ago Display
public extension Date {
  func timeAgoDisplay() -> String {
    let now = Date()
    let timeInterval = now.timeIntervalSince(self)
    
    if timeInterval < 60 {
      return "방금 전"
    } else if timeInterval < 3600 {
      let minutes = Int(timeInterval / 60)
      return "\(minutes)분 전"
    } else if timeInterval < 86400 {
      let hours = Int(timeInterval / 3600)
      return "\(hours)시간 전"
    } else if timeInterval < 604800 {
      let days = Int(timeInterval / 86400)
      return "\(days)일 전"
    } else {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd"
      return formatter.string(from: self)
    }
  }
}
