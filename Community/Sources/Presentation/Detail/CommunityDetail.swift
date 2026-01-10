//
//  CommunityDetail.swift
//  Hambug
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI
import DesignSystem
import CommunityDomain
import SharedUI
public struct CommunityDetailView: View {
  private func timeAgoDisplay(_ date: Date) -> String {
    let now = Date()
    let timeInterval = now.timeIntervalSince(date)

    if timeInterval < 60 {
      return "방금 전"
    } else if timeInterval < 3600 {
      let minutes = Int(timeInterval / 60)
      return "\(minutes)분 전"
    } else if timeInterval < 86400 {
      let hours = Int(timeInterval / 3600)
      return "\(hours)시간 전"
    } else if timeInterval < 604800 {
      let days = Int(timeInterval / 86400)
      return "\(days)일 전"
    } else {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd"
      return formatter.string(from: date)
    }
  }
}

struct EllipsisButton: View {
  private let action: () -> Void
  var body: some View {
    Button {
      action()
    } label: {
      Color.bgEllipsis
        .frame(width: 24, height: 24)
        .clipShape(Circle())
        .overlay {
          Image(systemName: "ellipsis")
            .rotationEffect(.degrees(90.0))
            .font(.system(size: 14))
            .foregroundColor(.iconG600)
        }
    }
  }
  
  init(action: @escaping @MainActor () -> Void) {
    self.action = action
  }
}
