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
    // ISO 8601 문자열을 Date로 변환
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    self.createdAt = "\(formatter.string(from: response.createdAt))분 전"
  }  
}
