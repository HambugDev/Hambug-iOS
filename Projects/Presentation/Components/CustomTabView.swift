//
//  CustomTabView.swift
//  Hambug
//
//  Created by 강동영 on 12/12/25.
//

import DesignSystem
import SwiftUI

struct CustomTabView<Content: View>: View {
  private let tabConfig: [HambugTab]
  @ViewBuilder let content: Content

  @Binding private var selectedTab: Int
  
  var body: some View {
    VStack(spacing: 0) {
      // Content area
      TabView(selection: $selectedTab) {
        content
      }
      .tabViewStyle(.page(indexDisplayMode: .never))

      // Custom Tab Bar
      HStack(spacing: 0) {
        ForEach(tabConfig) { tab in
          TabBarItem(
            config: tab,
            isSelected: selectedTab == tab.id
          ) {
            selectedTab = tab.id
          }
        }
      }
      .frame(height: UIScreen.main.bounds.height * 0.11)
      .background(
        Color.white
          .cornerRadius(30, corners: [.topLeft, .topRight])
      )
      .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
    }
    .ignoresSafeArea(.all, edges: .vertical)
  }

  init(
    selectedTab: Binding<Int>,
    tabConfig: [HambugTab] = HambugTab.allCases,
    @ViewBuilder content: () -> Content,
  ) {
    self._selectedTab = selectedTab
    self.tabConfig = tabConfig
    self.content = content()
  }
}

// MARK: CustomTabView 의 HambugTab
extension CustomTabView {
  enum HambugTab: Int, CaseIterable, Identifiable {
    case home = 0
    case community = 1
    case myPage = 2

    var id: Int { rawValue }
    
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
  fileprivate struct TabBarItem: View {
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


// MARK: Style 관련 객체들
fileprivate extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> SwiftUI.Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return SwiftUI.Path(path.cgPath)
  }
}

#Preview {
  @Previewable @State var selectedTab = 0

  CustomTabView(selectedTab: $selectedTab) {
    Text("Preview")
  }
}
