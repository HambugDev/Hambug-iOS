//
//  DesignSystemDemoView.swift
//  Hambug
//
//  Created by 강동영 on 8/26/25.
//

import SwiftUI

struct DesignSystemDemoView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("H1 - 28px SemiBold")
                        .foregroundStyle(.textG900)
                        .pretendard(.heading(.h1))
                        .background(.primaryHambugRed)
                    
                    
                    Text("H2 - 24px SemiBold")
                        .foregroundStyle(.white)
                        .pretendard(.heading(.h2))
                        .background(.primaryGray)
                    
                    Text("H3 - 22px Medium")
                        .pretendard(.heading(.h3))
                        .background(.secondaryOrange)
                }
                .padding()
                .background(.bgG200)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title 1 - 20px SemiBold")
                        .pretendard(.title(.t1))
                        .background(.secondaryYellow)
                    
                    Text("Title 2 - 18px SemiBold")
                        .pretendard(.title(.t2))
                        .background(.secondaryGreen)
                }
                .padding()
                .background(.bgG50)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Body Base - 16px Regular\n멀티라인 테스트를 위한\n세번째 줄입니다")
                        .foregroundStyle(.white)
                        .pretendard(.body(.base))
                        .background(.secondaryBrown)
                    
                    Text("Body Base Emphasis - 16px Medium\n멀티라인 테스트를 위한\n세번째 줄입니다")
                        .foregroundStyle(.textG800)
                        .pretendard(.body(.bEmphasis))
                        .padding()
                        .background(.bgG200)
                        .border(.borderG500, width: 2)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Body Small - 14px Regular")
                            .foregroundStyle(.textG600)
                            .pretendard(.body(.small))
                            .background(.cyan)
                        
                        Text("Body Small Emphasis - 14px Medium\n멀티라인 테스트를 위한\n세번째 줄입니다")
                            .pretendard(.body(.sEmphasis))
                            .padding()
                            .border(.borderG400, width: 2)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption - 12px Regular")
                            .pretendard(.caption(.base))
                            .background(.gray)
                        
                        Text("Caption Emphasis - 12px Medium\n멀티라인 테스트를 위한\n세번째 줄입니다")
                            .pretendard(.caption(.emphasis))
                            .padding()
                            .background(.mint)
                            .border(.borderG400, width: 2)
                    }
                    .padding()
                    .background(.bgYellow)
                }
                .padding()
                .background(.bgWhite)
                
                Spacer()
            }
            .background(.bgG100)
            .padding()
        }
        
    }
}

#Preview {
    DesignSystemDemoView()
}
