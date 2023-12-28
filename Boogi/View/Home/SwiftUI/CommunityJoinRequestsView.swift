//
//  CommunityJoinRequestView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/22.
//

import Foundation
import SwiftUI

struct CommunityJoinRequestsView: View {
    let communityId: Int
    @State var checkMode: Bool = false
    @State var requests: JoinRequests?
    @State var requestIds: [Int] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(requests?.requests ?? [], id: \.self) { request in
                    JoinRequest(request: request, checkMode: $checkMode, requestIds: $requestIds)
                }
            }
            
            Spacer()
            
            if checkMode {
                HStack {
                    Button {
                        Task {
                            try await WebService.webService.postCommunityJoinRequestConfirm(communityId: communityId, requestIds: requestIds)
                            checkMode = false
                            requestIds.forEach { id in
                                requests?.requests.removeAll {
                                    $0.id == id
                                }
                            }
                            requestIds.removeAll()
                        }
                    } label: {
                        Text("수락")
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            try await WebService.webService.postCommunityJoinRequestReject(communityId: communityId, requestIds: requestIds)
                            checkMode = false
                            requestIds.forEach { id in
                                requests?.requests.removeAll {
                                    $0.id == id
                                }
                            }
                            requestIds.removeAll()
                        }
                    } label: {
                        Text("거절")
                    }
                }
                .padding()
            }
        }
        .navigationTitle("가입승인")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    checkMode.toggle()
                } label: {
                    if !checkMode {
                        Image(systemName: "checkmark")
                    } else {
                        Text("모두해제")
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .animation(.default, value: checkMode)
        .task {
            requests = try? await WebService.webService.getJoinRequests(communityId: communityId)
        }
    }
}
