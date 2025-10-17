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
                        .foregroundStyle(Color.textG900)
                        .pretendard(.heading(.h1))
                        .background(Color.primaryHambugRed)
                    
                    
                    Text("H2 - 24px SemiBold")
                        .foregroundStyle(.white)
                        .pretendard(.heading(.h2))
                        .background(Color.primaryGray)
                    
                    Text("H3 - 22px Medium")
                        .pretendard(.heading(.h3))
                        .background(Color.secondaryOrange)
                }
                .padding()
                .background(Color.bgG200)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title 1 - 20px SemiBold")
                        .pretendard(.title(.t1))
                        .background(Color.secondaryYellow)
                    
                    Text("Title 2 - 18px SemiBold")
                        .pretendard(.title(.t2))
                        .background(Color.secondaryGreen)
                }
                .padding()
                .background(Color.bgG50)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Body Base - 16px Regular\n멀티라인 테스트를 위한\n세번째 줄입니다")
                        .foregroundStyle(.white)
                        .pretendard(.body(.base))
                        .background(Color.secondaryBrown)
                    
                    Text("Body Base Emphasis - 16px Medium\n멀티라인 테스트를 위한\n세번째 줄입니다")
                        .foregroundStyle(Color.textG800)
                        .pretendard(.body(.bEmphasis))
                        .padding()
                        .background(Color.bgG200)
                        .border(Color.borderG500, width: 2)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Body Small - 14px Regular")
                            .foregroundStyle(Color.textG600)
                            .pretendard(.body(.small))
                            .background(.cyan)
                        
                        Text("Body Small Emphasis - 14px Medium\n멀티라인 테스트를 위한\n세번째 줄입니다")
                            .pretendard(.body(.sEmphasis))
                            .padding()
                            .border(Color.borderG400, width: 2)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption - 12px Regular")
                            .pretendard(.caption(.base))
                            .background(.gray)
                        
                        Text("Caption Emphasis - 12px Medium\n멀티라인 테스트를 위한\n세번째 줄입니다")
                            .pretendard(.caption(.emphasis))
                            .padding()
                            .background(.mint)
                            .border(Color.borderG400, width: 2)
                    }
                    .padding()
                    .background(Color.bgYellow)
                }
                .padding()
                .background(Color.bgWhite)
                
                Spacer()
            }
            .background(Color.bgG100)
            .padding()
        }
        
    }
}

//#Preview {
//    DesignSystemDemoView()
//}
