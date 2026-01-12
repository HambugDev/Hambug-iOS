//
//  MyPage+LocalizedString.swift
//  MyPage
//
//  Created by 강동영 on 12/19/25.
//


import LocalizedString
import SwiftUI

extension Text {
    @inlinable
    public init(myPage: KeyPath<String.LocalizedString.MyPage.Type, String>) {
      let value = String.LocalizedString.MyPage.self[keyPath: myPage]
        self.init(verbatim: value)
    }
}

extension String.LocalizedString {
  enum Login {
    static let hello: String = "안녕하세요."
    static let hambug: String = "햄버그"
    static let hambugSuffix: String = "입니다 :)"
    static let descriptionOfSNS: String = "SNS 계정으로 간편 가입하기"
  }
  
  public enum MyPage {
    static let header: String = "마이페이지"
    struct ActionSheetTitle2 {
      static let profile = "프로필 설정"
    }
    public enum ActionSheetTitle {
      static let profile = "프로필 설정"
      static let changeNickname = "닉네임 변경"
      static let changeImage = "프로필 이미지 변경"
      static let defaultImage = "기본 이미지 적용"
    }
//    enum Strings {
//      enum ActionSheetTitle {
//        static let profile = "프로필 설정"
//        static let changeNickname = "닉네임 변경"
//        static let changeImage = "프로필 이미지 변경"
//        static let defaultImage = "기본 이미지 적용"
//      }
//      
//      enum CardTitle {
//        static let activity = "활동 내역"
//        static let logout = "로그아웃"
//        static let accountDelete = "탈퇴하기"
//      }
//      
//      enum PopupTitle {
//        static let changeNickname = "닉네임 변경"
//        static let logout = "로그아웃 하시겠어요?"
//        static let deleteAccount = "정말 탈퇴하시겠어요?"
//        static let deleteSuccess = "회원 탈퇴가 완료되었습니다."
//      }
//      
//      enum PopupMessage {
//        static let deleteAccount = "회원탈퇴 후 계정 복구가 불가능하며, 작성한 게시글과 댓글은 유지됩니다. 탈퇴하시겠습니까?"
//      }
//    }
  }


  enum MyPageBottomLineTextField {
    enum PopupMessage {
      static let isCorrected = "닉네임을 다시 확인해주세요"
    }
  }
}


