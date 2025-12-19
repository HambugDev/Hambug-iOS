//
//  SuggestView.swift
//  Hambug
//
//  Created by 차상진 on 9/12/25.
//

import SwiftUI

public struct SuggestView: View {
    public init() {}

    public var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    SingleSuggestView()
                    SingleSuggestView()
                    SingleSuggestView()
                }
                
                .padding(.vertical, 30)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, SuggestSizeValue.shared.safeAreaPadding)
            .scrollIndicators(.hidden)
            
        }
        
    }
}


struct SingleSuggestView: View {
    var body: some View {
        Rectangle()
            .frame(width: SuggestSizeValue.shared.singleSuggestViewWidth, height: 200)
            .foregroundColor(.gray)
            .cornerRadius(13)
        
        VStack {
            
        }
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
  SuggestView()
}
