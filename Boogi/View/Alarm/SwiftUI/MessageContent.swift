//
//  MessageContent.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/24.
//

import Foundation
import SwiftUI

struct MessageContent: View {
    // @Environment(\.dismiss) var dismiss
    let msg: MessageDetail.Message
    @State var reporting = false
    
    var body: some View {
        HStack {
            if msg.me {
                Spacer()
            }
            
            VStack(alignment: msg.me ? .trailing : .leading) {
                Text(msg.content)
                Text(msg.receivedAt)
                    .foregroundColor(.gray)
                    .font(.caption)
                
            }
            .padding()
            .background(msg.me ? .blue.opacity(0.5) : .gray.opacity(0.5))
            .cornerRadius(10)
            .contextMenu {
                Button {
                    reporting = true
                } label: {
                    Text("신고")
                        .foregroundColor(.red)
                }
            }
            
            if !msg.me {
                Spacer()
            }
        }
        .padding([.leading, .trailing])
        .sheet(isPresented: $reporting) {
            ZStack(alignment: .topTrailing) {
                ReportCreateView(createReport: CreateReport(id: msg.id, target: "MESSAGE"), reporting: $reporting)
                
                Button {
                    reporting = false
                } label: {
                    Image(systemName: "xmark")
                        .padding(20)
                }
                
            }
        }
    }
}
