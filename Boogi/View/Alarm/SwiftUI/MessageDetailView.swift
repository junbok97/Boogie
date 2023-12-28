//
//  MessageDetailView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/10.
//

import Foundation
import SwiftUI

struct MessageDetailView: View {
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    let opponentId: Int
    @Namespace var bottom
    @State var msg: String = ""
    @State var detail: MessageDetail = MessageDetail(
        user: MessageDetail.User(
            id: 1,
            name: "",
            tagNum: "",
            profileImageUrl: ""
        ),
        messages: [],
        pageInfo: MessageDetail.PageInfo(
            nextPage: 0,
            totalCount: 0,
            hasNext: false
        )
    )
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(detail.messages, id: \.self) { msg in
                    MessageContent(msg: msg)
                }
                .animation(.default, value: detail.messages.count)
                .onAppear {
                    proxy.scrollTo(bottom)
                }
                
                HStack { }.id(bottom)
            }
            
            MessageTextBar(
                msg: $msg,
                proxy: proxy,
                bottom: bottom,
                detail: $detail
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    AsyncImage(url: URL(string: detail.user.profileImageUrl ?? "")) { img in
                        img.resizable()
                    } placeholder: {
                        if downloadAmount < 100 {
                            ProgressView()
                                .onReceive(timer) { _ in
                                    if downloadAmount < 100 {
                                        downloadAmount += 5
                                    } else {
                                        timer.upstream.connect().cancel()
                                    }
                                }
                        } else {
                            Image(systemName: "person.fill")
                        }
                    }
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(detail.user.name)
                            .foregroundColor(.white)
                        Text(detail.user.tagNum)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            
            /// TODO: 유저 차단
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("") {
                    // ReportCreateView(createReport: CreateReport(id: detail.user.id, target: "USER"))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .task {
            do {
                detail = try await WebService.webService.getMessageDetail(opponentId: opponentId)
            } catch {
            }
        }
    }
}
