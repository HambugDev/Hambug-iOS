//
//  CustomTabView.swift
//  Hambug
//
//  Created by 강동영 on 12/12/25.
//

import DesignSystem
import SwiftUI

public struct CustomTabView<Content: View>: View {
  private let tabConfig: [HambugTab]
  @ViewBuilder let content: Content

  @Binding private var selectedTab: Int
  @State private var isTabBarHidden: Bool = false

  public var body: some View {
    VStack(spacing: 0) {
      // Content area
      TabView(selection: $selectedTab) {
        content
          .syncTabBarVisibility(with: $isTabBarHidden)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))

      // Custom Tab Bar
      if !isTabBarHidden {
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
        .transition(.move(edge: .bottom).combined(with: .opacity))
      }
    }
    .ignoresSafeArea(.all, edges: .vertical)
  }

  public init(
    selectedTab: Binding<Int>,
    tabConfig: [HambugTab] = HambugTab.allCases,
    @ViewBuilder content: () -> Content
  ) {
    self._selectedTab = selectedTab
    self.tabConfig = tabConfig
    self.content = content()
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


//
//#Preview {
//  @Previewable @State var selectedTab = 0
//
//  CustomTabView(selectedTab: $selectedTab) {
//    Text("Preview")
//  }
//}
