//
//  MyPageView.swift
//  Hambug
//
//  Created by 강동영 on 10/27/25.
//

import SwiftUI

public struct MyPageView: View {
  @StateObject var viewModel: MyPageViewModel
  
  public var body: some View {
    Text("My Page")
  }
  
  public init(viewModel: MyPageViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
}


