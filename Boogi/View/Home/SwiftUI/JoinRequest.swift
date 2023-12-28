//
//  JoinRequest.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/25.
//

import Foundation
import SwiftUI

struct JoinRequest: View {
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    let request: JoinRequests.Request
    @Binding var checkMode: Bool
    @Binding var requestIds: [Int]
    @State var isChecked: Bool = false
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: request.user.profileImageUrl ?? "")) { img in
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
            VStack {
                Text(request.user.name)
                Text(request.user.tagNum)
            }
            Spacer()
            
            if checkMode {
                Button {
                    isChecked ?
                        (requestIds.removeAll { $0 == request.id }) :
                        (requestIds.append(request.id))
                    
                    isChecked.toggle()
                } label: {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "checkmark.square")
                }
            }
        }
    }
}
