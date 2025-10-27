//
//  DeleteConfirmationPopup.swift
//  Hambug
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI
import DesignSystem

struct DeleteConfirmationPopup: View {
    @Binding var isPresented: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                    onCancel()
                }
            
            VStack(spacing: 0) {
                iconSection
                messageSection
                buttonSection
            }
            .frame(width: 280)
            .background(Color.bgWhite)
            .cornerRadius(16)
            .scaleEffect(isPresented ? 1.0 : 0.8)
            .opacity(isPresented ? 1.0 : 0.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPresented)
        }
    }
    
    private var iconSection: some View {
        VStack(spacing: 16) {
            ZStack {
              Image(.hambugLogo)
                .frame(width: 60, height: 60)
            }
        }
        .padding(.top, 32)
    }
    
    private var messageSection: some View {
        VStack(spacing: 8) {
            Text("게시물을 삭제하시겠어요?")
                .pretendard(.title(.t2))
                .foregroundColor(.textG900)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
    }
    
    private var buttonSection: some View {
        HStack(spacing: 8) {
            Button {
                isPresented = false
                onCancel()
            } label: {
                Text("취소")
                    .pretendard(.body(.bEmphasis))
                    .foregroundColor(.textG600)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.bgG100)
                    )
            }
            
            Button {
                isPresented = false
                onConfirm()
            } label: {
                Text("삭제")
                    .pretendard(.body(.bEmphasis))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primaryHambugRed)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
}

struct DeleteConfirmationPopup_Previews: PreviewProvider {
    static var previews: some View {
        DeleteConfirmationPopup(
            isPresented: .constant(true),
            onConfirm: {},
            onCancel: {}
        )
    }
}
