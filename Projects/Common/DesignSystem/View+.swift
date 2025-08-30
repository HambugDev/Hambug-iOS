//
//  View+.swift
//  Hambug
//
//  Created by 강동영 on 8/26/25.
//

import SwiftUI

extension View {
    // MARK: - font, linespacing 적용되어있음 (기본값: Pretendard)
    func pretendard(_ style: TextStyle) -> some View {
        let pretendardProvider = PretendardProvider()
        let fontStyle = style.getFontStyle(with: pretendardProvider)
        return self
            .font(fontStyle.font)
            .lineSpacing(fontStyle.lineHeight)
    }
}
