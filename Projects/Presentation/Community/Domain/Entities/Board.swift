//
//  Board.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation

// MARK: - Board Entity
struct Board: Identifiable, Equatable {
  let id: Int
  let imageURL: String
  let title: String
  let nickName: String
  let content: String
  let createdAt: String
  let likeCount: String
  let commnetCount: String
  
  // Preview용 샘플 데이터
  static var sampleData: [Board] {
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

// MARK: - BoardResponse to Board Mapper
extension Board {
  init(from response: BoardResponse) {
    self.id = response.id
    self.imageURL = response.imageURL
    self.title = response.title
    self.nickName = response.nickName
    self.content = response.content ?? ""
    self.likeCount = response.likeCount
    self.commnetCount = response.commnetCount
    // Date를 사용자 친화적 형식으로 변환
    self.createdAt = response.createdAt.timeAgoDisplay()
  }  
}

// MARK: - Date Extension for Time Ago Display
extension Date {
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
