//
//  ContentView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedTab = 0
  
  var body: some View {
    CustomTabView(
      selectedTab: $selectedTab
    )
  }
}

//MARK: - Preview
#Preview {
    ContentView()
}
