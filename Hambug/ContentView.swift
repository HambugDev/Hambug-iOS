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
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: HomeDIContainer(appContainer: appContainer).homeViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(0)

#if DEBUG
          CommunityView(container: CommunityDIContainer(appContainer: appContainer, isMock: true))
            .tabItem {
              Image(systemName: "person.2.fill")
              Text("커뮤니티")
            }
            .tag(1)
#else
          CommunityView(container: CommunityDIContainer(appContainer: appContainer))
            .tabItem {
              Image(systemName: "person.2.fill")
              Text("커뮤니티")
            }
            .tag(1)
#endif
        }
    }
}


//MARK: - Preview
#Preview {
    ContentView()
        .environment(AppDIContainer.shared)
}
