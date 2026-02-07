//
//  TabBarVisibilityKey.swift
//  Common
//
//  Created by 강동영 on 1/9/26.
//

import SwiftUI

// MARK: - TabBar Visibility Environment
private struct TabBarVisibilityKey: EnvironmentKey {
  static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
  var tabBarVisibility: Binding<Bool> {
    get { self[TabBarVisibilityKey.self] }
    set { self[TabBarVisibilityKey.self] = newValue }
  }
}

public extension View {
  /// 커스텀 탭바를 숨기거나 표시합니다.
  /// - Parameter hidden: true면 탭바를 숨기고, false면 탭바를 표시합니다.
  func tabBarHidden(_ hidden: Bool) -> some View {
    self
      .onAppear {
        // View가 나타날 때 preference를 강제로 다시 전파
        // 이렇게 하면 NavigationStack에서 pop 시에도 제대로 갱신됨
      }
      .preference(key: TabBarVisibilityPreference.self, value: hidden)
  }
}

private struct TabBarVisibilityPreference: @MainActor PreferenceKey {
  @MainActor static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    // 자식 View의 preference가 우선
    // true(숨김)가 있으면 true를 우선시
    let next = nextValue()
    if next {
      value = next
    }
  }
}

extension View {
  func syncTabBarVisibility(with binding: Binding<Bool>) -> some View {
    self.onPreferenceChange(TabBarVisibilityPreference.self) { newValue in
      withAnimation(.easeInOut(duration: 0.2)) {
        binding.wrappedValue = newValue
      }
    }
  }
}
