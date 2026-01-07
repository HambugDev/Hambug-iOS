//
//  TextStyle.swift
//  Hambug
//
//  Created by 강동영 on 8/26/25.
//

import Foundation

public enum TextStyle {
    case heading(TextStyle.Heading)
    case title(TextStyle.Title)
    case body(TextStyle.Body)
    case caption(TextStyle.Caption)
    
    public enum Heading { case h1, h2, h3 }
    public enum Title { case t1, t2 }
    public enum Body { case base, bEmphasis, small, sEmphasis }
    public enum Caption { case base, emphasis }
    
    // MARK: - 폰트에 의존하지 않는 스타일 정의
    private var styleSpec: (weight: FontWeight, size: CGFloat) {
        switch self {
        case .heading(let heading):
            switch heading {
            case .h1: return (.semiBold, 28)
            case .h2: return (.semiBold, 24)
            case .h3: return (.medium, 22)
            }
            
        case .title(let title):
            switch title {
            case .t1: return (.semiBold, 20)
            case .t2: return (.semiBold, 18)
            }
            
        case .body(let body):
            switch body {
            case .base: return (.regular, 16)
            case .bEmphasis: return (.semiBold, 16)
            case .small: return (.regular, 14)
            case .sEmphasis: return (.semiBold, 14)
            }
            
        case .caption(let caption):
            switch caption {
            case .base: return (.regular, 12)
            case .emphasis: return (.semiBold, 12)
            }
        }
    }
    
    // MARK: - FontProvider를 받아서 FontStyle 생성
    public func getFontStyle(with provider: FontProvider) -> FontStyle {
        let spec = styleSpec
        let fontName = spec.weight.getFontName(from: provider)
        return FontStyle(.custom(fontName), size: spec.size)
    }
}
