//
//  BorderTextEditor.swift
//  Hambug
//
//  Created by 강동영 on 10/28/25.
//

import SwiftUI

public struct BorderTextEditor: View {
  private let contentPlaceholder = "자유롭게 이야기를 나눠보세요"
  private let maxCharacterCount: Int

  @State private var characterCount: Int = 0
  @Binding var content: String

  private var isCharacterMax: Bool {
    characterCount >= maxCharacterCount
  }
  
  public var body: some View {
    VStack(spacing: 2) {
      if isCharacterMax {
        HStack {
          Spacer()
          Text("내용은 \(maxCharacterCount)자를 넘길 수 없습니다")
            .pretendard(.caption(.base))
            .foregroundColor(.textR100)
        }
      }
      
      ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: 8)
          .stroke(isCharacterMax ? Color.borderR100 : Color.borderG400, lineWidth: 1)
          .background(Color.bgG75)
          .frame(minHeight: 234)
        
        TextEditor(text: $content)
          .pretendard(.body(.small))
          .padding(.horizontal, 12)
          .padding(.vertical, 10)
          .background(.clear)
          .scrollContentBackground(.hidden)
          .onChange(of: content) { _, newValue in
            characterCount = newValue.count
            if newValue.count > maxCharacterCount {
              content = String(newValue.prefix(maxCharacterCount))
              characterCount = maxCharacterCount
            }
          }
        
        if content.isEmpty {
          Text(contentPlaceholder)
            .pretendard(.body(.small))
            .foregroundColor(.borderG300)
            .padding(.horizontal, 16)
            .padding(.top, 14)
        }
      }
    }
  }
  
  init(
    maxCharacterCount: Int = 300,
    content: Binding<String>
  ) {
    self.maxCharacterCount = maxCharacterCount
    self._content = content
  }
}
