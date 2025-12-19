//
//  ContentView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI
import AppDI

struct ContentView: View {
  @Environment(AppDIContainer.self) var appContainer
  
  private var homeDIContainer: HomeDIContainer {
    HomeDIContainer(appContainer: appContainer)
  }
  
  private var communityDIContainer: CommunityDIContainer {
    CommunityDIContainer(appContainer: appContainer)
  }
  
  @State private var selectedTab: Int = 0
  
  var body: some View {
    CustomTabView(selectedTab: $selectedTab) {
      HomeView(viewModel: homeDIContainer.homeViewModel)
        .tag(0)
      
      CommunityView(container: communityDIContainer)
        .tag(1)
      
      Text("MyPage")
        .tag(2)
    }
  }
}


//MARK: - Preview
#Preview {
    ContentView()
        .environment(AppDIContainer.shared)
}
