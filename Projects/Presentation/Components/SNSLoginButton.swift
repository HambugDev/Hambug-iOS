//
//  SNSLoginButton.swift
//  Hambug
//
//  Created by 차상진 on 9/25/25.
//

import Foundation
import SwiftUI

struct SNSLoginButton: View {
    let width = UIScreen.main.bounds.width * 0.8
    
    var loginType: LoginType
    var action: () -> Void
    
    init(_ loginType: LoginType, action: @escaping () -> Void) {
        self.loginType = loginType
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(loginType.logoName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26)
                    
                
                Text("\(loginType.rawValue) 로그인")
                    .foregroundColor(loginType.fontColor)
                    .pretendard(.title(.t2))
            }
            .frame(width: width, height: 50)
            .background(loginType.bgColor)
            .cornerRadius(14)
        }
    }
}
