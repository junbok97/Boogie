//
//  Easter.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/28.
//

import Foundation
import SwiftUI

struct EasterView: View {
    @State var email: String = ""
    @State var confirm: Bool = false
    @Binding var easter: Bool
    @Binding var easterCnt: Int
    
    var body: some View {
        Form {
            Section("E-mail") {
                TextField("E-mail", text: $email)
                    .textFieldStyle(.roundedBorder)
            }
            
            
            HStack {
                Button {
                    confirm = true
                    Task {
                        UserInfo.userInfo.email = email
                        UserInfo.userInfo.XAuthToken = nil
                        UserInfo.userInfo.XAuthToken = try? await WebService.webService.getToken(email: email)
                    }
                } label: {
                    Text("적용하기")
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
                Button {
                    easter = false
                    easterCnt = 0
                } label: {
                    Text("닫기")
                        .padding()
                        .background(Color.pink.opacity(0.5))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .alert("적용되었습니다", isPresented: $confirm) { }
    }
}
