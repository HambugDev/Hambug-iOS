//
//  MyPageCardView.swift
//  MyPage
//
//  Created by 강동영 on 12/19/25.
//

import SwiftUI

struct MyPageCardView: View {
  private let title: String
  private let image: ImageResource
  private let action: @MainActor () -> Void
  
  private var foregroundColor: Color = .textG800
  
  init(
    config: Config,
    foregroundColor: Color = .textG800,
    action: @escaping @MainActor () -> Void
  ) {
    self.title = config.title
    self.image = config.image
    self.action = action
  }
  
  init(
    title: String,
    image: ImageResource,
    foregroundColor: Color = .textG800,
    action: @escaping @MainActor () -> Void
  ) {
    self.title = title
    self.image = image
    self.action = action
  }
  
  var body: some View {
    Button {
      action()
    } label: {
      HStack(spacing: 0) {
        Label {
          Text(title)
        } icon: {
          Image(image)
            .resizable()
            .frame(width: 16, height: 16)
        }
        .pretendard(.body(.base))
        .foregroundStyle(foregroundColor)

        Spacer()
        
        Image(.mypageTriangleRight)
          .resizable()
          .frame(width: 16, height: 16)
      }
      .myPageCardStyle()
      
    }
  }
}

extension MyPageCardView {
  struct Config {
    let title: String
    let image: ImageResource
  }
}

extension MyPageCardView.Config {
  static let activity: Self = .init(title: "활동 내역", image: .myCardActivities)
  static let logout: Self = .init(title: "로그아웃", image: .myCardLogout)
  static let accountDelete: Self = .init(title: "탈퇴하기", image: .myCardDeleteAccount)
}

fileprivate extension MyPageCardView {
  func foregroundColor(_ color: Color) -> Self {
    var view = self
    view.foregroundColor = color
    return view
  }
}

fileprivate struct MyPageCardStyleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 20)
      .padding(.horizontal, 20)
      .background(
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.bgG100)
      )
  }
}

fileprivate extension View {
  func myPageCardStyle() -> some View {
    modifier(MyPageCardStyleModifier())
  }
}
