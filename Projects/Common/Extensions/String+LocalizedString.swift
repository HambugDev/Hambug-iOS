//
//  LocalizedString.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//

extension String {
  enum LocalizedString {}
}

extension String.LocalizedString {
  enum Login {
    static let hello: String = "안녕하세요."
    static let hambug: String = "햄버그"
    static let hambugSuffix: String = "입니다 :)"
    static let descriptionOfSNS: String = "SNS 계정으로 간편 가입하기"
  }
}
