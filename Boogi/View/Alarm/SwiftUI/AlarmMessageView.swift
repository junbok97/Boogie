//
//  AlarmNoteView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/06.
//

import Foundation
import SwiftUI

struct AlarmMessageView: View {
    @State var selection = 0
    @State var easter: Bool = false
    @State var easterCnt = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    selection = 0
                    easterCnt += 1
                    if 10 < easterCnt {
                        easter = true
                    }
                } label: {
                    Text("알림")
                        .foregroundColor(selection == 0 ? .blue : .black)
                }
                
                Spacer()
                
                Button {
                    selection = 1
                } label: {
                    Text("쪽지")
                        .foregroundColor(selection == 1 ? .blue : .black)
                }
                
                Spacer()
            }
            .padding()
            .background(.gray.opacity(0.5))
            
            
            switch selection {
            case 0:
                AlarmView()
            case 1:
                MessageListView()
            default:
                ProgressView()
            }
            
            Spacer()
        }
        .animation(.default, value: selection)
        .navigationTitle("알림 및 쪽지")
        .sheet(isPresented: $easter) {
            EasterView(easter: $easter, easterCnt: $easterCnt)
        }
    }
}
