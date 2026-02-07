//
//  AlarmListView.swift
//  Home
//
//  Created by 강동영 on 1/14/26.
//

import SwiftUI
import AlarmDomain
import DesignSystem

public protocol AlarmListDependecy: AlarmListFactory {}


public protocol AlarmListFactory {
  func makeAlarmListViewModel() -> AlarmListViewModel
}

public struct AlarmListView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: AlarmListViewModel
  private let dependency: AlarmListDependecy
  
  public init(dependency: AlarmListDependecy) {
    self.dependency = dependency
    self._viewModel = State(initialValue: dependency.makeAlarmListViewModel())
  }
  
  public var body: some View {
    VStack {
      navigationBar
      
      ScrollView {
        ForEach(viewModel.palyload) { prop in
          LazyVStack {
            AlarmView(prop)
          }
        }
      }
      .task {
        await viewModel.fetchAlarmList()
      }
    }
    .toolbar(.hidden, for: .navigationBar)
  }
  
  private var navigationBar: some View {
    HStack {
      Button {
        dismiss()
      } label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(.iconG800)
      }
      
      Spacer()
      
      Text("알림")
        .pretendard(.title(.t2))
        .foregroundColor(.textG900)
      
      Spacer()
      
      Color.clear
        .frame(width: 18, height: 18)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.bgWhite)
  }
}

struct AlarmView: View {
  private let payload: AlarmPayload
  
  init(_ payload: AlarmPayload) {
    self.payload = payload
  }
  var body: some View {
    HStack(spacing: 10) {
      VStack(alignment: .leading, spacing: 4) {
        Text(payload.date)
          .pretendard(.caption(.base))
          .foregroundColor(Color.textG600)
        Text(payload.content)
          .pretendard(.body(.sEmphasis))
          .foregroundColor(Color.textG800)
      }
      
      if let imageURL = payload.imageUrl {
        Spacer()
        
        AsyncThumbnailImage(
          imageURL: imageURL,
          width: 40,
          height: 40,
          cornerRadius: 0
        )
      }

    }
      .padding(16)
  }
}

//#Preview {
//  AlarmListView()
//}

