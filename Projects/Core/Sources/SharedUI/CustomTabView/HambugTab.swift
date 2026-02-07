//
//  HambugTab.swift
//  Common
//
//  Created by 강동영 on 1/9/26.
//

import SwiftUI

// MARK: CustomTabView 의 HambugTab
extension CustomTabView {
  public enum HambugTab: Int, CaseIterable, Identifiable {
    case home = 0
    case community = 1
    case myPage = 2

    public var id: Int { rawValue }

    var iconName: String {
      switch self {
      case .home:
        "tab_home"
      case .community:
        "tab_community"
      case .myPage:
        "tab_user"
      }
    }

    var title: String {
      switch self {
      case .home:
        "홈"
      case .community:
        "커뮤니티"
      case .myPage:
        "마이"
      }
    }
  }
}

// MARK: TabBarItem
extension CustomTabView {
  struct TabBarItem: View {
    private let config: HambugTab
    private let isSelected: Bool
    private let action: () -> Void

    var body: some View {
      Button(action: action) {
        VStack(spacing: 8) {
          Image(config.iconName)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 21, height: 21)

          Text(config.title)
            .pretendard(.caption(.emphasis))
        }
        .foregroundColor(isSelected ? .primaryHambugRed : .borderG400)
        .frame(maxWidth: .infinity)
      }
    }

    init(
      config: HambugTab,
      isSelected: Bool,
      action: @escaping () -> Void
    ) {
      self.config = config
      self.isSelected = isSelected
      self.action = action
    }
  }
}
