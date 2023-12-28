//
//  MessageTextBar.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/25.
//

import Foundation
import SwiftUI

struct MessageTextBar: View {
    @Binding var msg: String
    let proxy: ScrollViewProxy
    let bottom: Namespace.ID
    @Binding var detail: MessageDetail
    
    var body: some View {
        ZStack {
            TextField("Message", text: $msg, onCommit: {
                Task {
                    do {
                        if msg == "" { return }
                        let id = try await WebService.webService.postMessage(opponentId: detail.user.id, msg: msg)
                        detail.messages.append(
                            MessageDetail.Message(id: id, content: msg, receivedAt: getCurrent(), me: true)
                        )
                        msg = ""
                        proxy.scrollTo(bottom)
                    } catch {
                    }
                }
            })
            .padding()
            .background(.gray.opacity(0.1))
            
            HStack {
                Spacer()
                
                Button {
                    Task {
                        do {
                            if (msg == "") { return }
                            let id = try await WebService.webService.postMessage(opponentId: detail.user.id, msg: msg)
                            detail.messages.append(
                                MessageDetail.Message(id: id, content: msg, receivedAt: getCurrent(), me: true)
                            )
                            msg = ""
                            proxy.scrollTo(bottom)
                        } catch {
                        }
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .padding(.trailing, 20)
                }
            }
        }
    }
    
    func getCurrent() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date) % 100
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)

        return "\(year).\(month).\(day) \(hour):\(minutes)"
    }
}
