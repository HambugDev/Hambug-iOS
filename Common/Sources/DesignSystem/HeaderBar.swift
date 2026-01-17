//
//  HeaderBar.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import SwiftUI

public enum HeaderType {
  case home
  case community
  case myPage
  
  var displayText: String {
    switch self {
    case .home:
      return "햄버그"
    case .community:
      return "커뮤니티"
    case .myPage:
      return "마이페이지"
    }
  }
  
  var hasNotification: Bool {
    switch self {
    case .home, .community: return true
    case .myPage: return false
    }
  }
}
// 상단 헤더 - 로고, 알림
public struct HeaderBar<Destination: View>: View {
  private let fontStyle: FontStyle
  private let type: HeaderType
  private let destination: Destination?
  
  public init(
    type: HeaderType,
    @ViewBuilder destination: () -> Destination
  ) where Destination: View {
    fontStyle = .init(.custom("GeekbleMalang2"), size: 24.0)
    self.type = type
    self.destination = destination()
  }
  
  public init(type: HeaderType) where Destination == EmptyView {
    fontStyle = .init(.custom("GeekbleMalang2"), size: 24.0)
    self.type = type
    self.destination = nil
  }
  
  @ViewBuilder
  var titleSection: some View {
    switch type {
    case .home:
      HStack(spacing: 4) {
        Image("hambug_icon")
          .resizable()
          .frame(width: 28, height: 26)
        
        Text(type.displayText)
          .font(fontStyle.font)
          .lineSpacing(fontStyle.lineHeight)
          .foregroundColor(.primaryHambugRed)
      }
      
    case .community, .myPage:
      Text(type.displayText)
        .pretendard(.title(.t2))
        .foregroundColor(type == .community ? .white : Color.textG900)
    }
  }
  
  @ViewBuilder
  var notificationSection: some View {
    if let destination {
      NavigationLink {
        destination
      } label: {
        Image("notification")
          .resizable()
          .renderingMode(.template)
          .frame(width: 30, height: 30)
          .foregroundStyle(type == .home ? .black : .white)
      }
    }
  }
  
  public var body: some View {
    HStack {
      titleSection
      Spacer()
      notificationSection
    }
  }
}

#Preview {
  HeaderBar(type: .home) {
    AnyView(Text("Destination"))
  }
  
  HeaderBar(type: .myPage)
}
