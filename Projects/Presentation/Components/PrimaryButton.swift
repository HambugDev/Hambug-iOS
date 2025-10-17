//
//  PrimaryButton.swift
//  Hambug
//
//  Created by 강동영 on 9/26/25.
//

import SwiftUI

// 로그인 버튼
public struct PrimaryButton: View {
    private let titleKey: String
    private let titleStyle: TextStyle
    private let action: @MainActor () -> Void
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(titleKey)
                .pretendard(titleStyle)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: 53)
                .background(
                    Capsule()
                        .fill(Color.primaryHambugRed)
                )
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 18)
    }
    
    public init(
        title: String,
        style: TextStyle,
        action: @escaping @MainActor () -> Void = {}
    ) {
        self.titleKey = title
        self.titleStyle = style
        self.action = action
    }
}
