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
      CustomTabView(selectedTab: $selectedTab)
    }
}


//MARK: - Preview
#Preview {
    ContentView()
        .environment(AppDIContainer.shared)
}
