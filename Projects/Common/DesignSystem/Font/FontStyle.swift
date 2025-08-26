//
//  FontStyle.swift
//  Hambug
//
//  Created by 강동영 on 8/26/25.
//

import SwiftUI

// MARK: - Font 타입 속성을 정의하는 구조체
public enum FontType: Equatable {
    case system(Font.Weight)
    case custom(String)
}

// MARK: - TextStyle 혹은 직접 활용도 가능하끔 구조 작성
public struct FontStyle {
    let font: Font
    let fontSize: CGFloat
    let lineHeight: CGFloat
    
    init(
        _ family: FontType = .system(.regular),
        size: CGFloat = 16,
        lineHeight: CGFloat = 1.5,
    ) {
        self.fontSize = size
        
        switch family {
        case .system(let weight):
            self.font = .system(size: size, weight: weight)
        case .custom(let fontName):
            self.font = .custom(fontName, size: size)
        }

        self.lineHeight = size * lineHeight - size
    }
}
