//
//  TextWithColoredSubstring.swift
//  Hambug
//
//  Created by 차상진 on 9/24/25.
//

import Foundation
import SwiftUI


struct TextWithColoredSubstring: View {
    var originalText: String
    var coloredSubstring: String
    
    var body: some View {
        if let coloredRange = originalText.range(of: coloredSubstring) {
            let beforeRange = originalText[..<coloredRange.lowerBound]
            let coloredText = originalText[coloredRange]
            let afterRange = originalText[coloredRange.upperBound...]
            
            return Text(beforeRange)
                .foregroundColor(.black)
                + Text(coloredText)
                    .foregroundColor(.pink)
                + Text(afterRange)
                    .foregroundColor(.black)
        } else {
            return Text(originalText)
                .foregroundColor(.black)
        }
    }
}
