//
//  SuggestView.swift
//  Hambug
//
//  Created by 차상진 on 9/12/25.
//

import SwiftUI
import DesignSystem
import HomeDomain

public struct SuggestView: View {
  let burgers: [RecommendedBurger]

  public init(burgers: [RecommendedBurger]) {
    self.burgers = burgers
  }

  public var body: some View {
    VStack(spacing: 12) {
      CategoryHeaderText("오늘의 추천 버거")

      if burgers.isEmpty {
        // 빈 상태
        HStack(spacing: 20) {
          SingleSuggestView(burger: nil)
          SingleSuggestView(burger: nil)
          SingleSuggestView(burger: nil)
        }
      } else {
        ScrollView(.horizontal) {
          HStack(spacing: 20) {
            ForEach(burgers) { burger in
              SingleSuggestView(burger: burger)
            }
          }
          .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
      }
    }
  }
}


struct SingleSuggestView: View {
  let burger: RecommendedBurger?

  var body: some View {
    VStack(spacing: 4) {
      if let burger = burger {
        AsyncImage(url: URL(string: burger.menuImage)) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } placeholder: {
          EmptyView()
        }
        .frame(width: 170, height: 170)
        .clipped()
        .padding(.top, 20)

        VStack(spacing: 0) {
          Text(burger.franchise)
            .pretendard(.title(.t2))
            .padding(7)
            .foregroundStyle(Color.bgWhite)
            .background(Color.primaryHambugRed)
            .clipShape(RoundedRectangle(cornerRadius: 4))

          Text(burger.menuName)
            .pretendard(.title(.t2))
            .frame(maxWidth: .infinity)

          Text(burger.menuDescription)
            .pretendard(.body(.small))
            .lineLimit(1)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
      } else {
        // Placeholder
//        Image(systemName: "birthday.cake")
//          .resizable()
//          .padding(.top, 20)
//          .frame(width: 170, height: 170)
        EmptyView()

        VStack(spacing: 0) {
          Text("franchiseChip")
            .pretendard(.title(.t2))
            .padding(7)
            .foregroundStyle(Color.bgWhite)
            .background(Color.primaryHambugRed)
            .clipShape(RoundedRectangle(cornerRadius: 4))
          Text("Menu Name")
            .pretendard(.title(.t2))
            .frame(maxWidth: .infinity)
          Text("Menu Descriptionaadasdasdasdasdaasdasd")
            .pretendard(.body(.small))
            .lineLimit(1)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
      }
    }
    .frame(width: 290 * 0.85, height: 290)
    .background(
      RoundedRectangle(cornerRadius: 15)
        .foregroundColor(Color.bgWhite)
    )
  }
}

class SuggestSizeValue {

    static let shared = SuggestSizeValue()

    var singleSuggestViewWidth: Double {
        UIScreen.main.bounds.size.width * 0.7
    }
    var safeAreaPadding: Double {
        (UIScreen.main.bounds.size.width - singleSuggestViewWidth) / 2
    }
}


#Preview {
  ZStack {
    Color.bgG75
    SuggestView(burgers: [])
  }

}
