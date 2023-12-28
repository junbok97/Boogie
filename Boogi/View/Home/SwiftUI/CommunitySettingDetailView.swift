//
//  CommunitySettingdetailView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/28.
//

import Foundation
import SwiftUI

struct CommunitySettingDetailView: View {
    let communityId: Int
    @State var settings: CommunitySettings = CommunitySettings(settingInfo: CommunitySettings.Info(isAuto: false, isSecret: false))
    
    var body: some View {
        VStack(spacing: 0) {
            Toggle("커뮤니티 비공개", isOn: $settings.settingInfo.isSecret)
                .padding()
                .background(.gray.opacity(0.1))
                .onChange(of: settings.settingInfo.isSecret, perform: { newValue in
                    Task {
                        try await WebService.webService.postCommunityIsSecretSettings(communityId: communityId, isSecret: newValue)
                    }
                })
            
            Toggle("자동 유저 승인", isOn: $settings.settingInfo.isAuto)
                .padding()
                .background(.gray.opacity(0.1))
                .onChange(of: settings.settingInfo.isAuto, perform: { newValue in
                    Task {
                        try await WebService.webService.postCommunityIsAutoSettings(communityId: communityId, isAuto: newValue)
                    }
                })
            
            NavigationLink {
                CommunityManagerDelegateView(communityId: communityId)
            } label: {
                Text("관리자 임명")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(.gray.opacity(0.1))
            
            NavigationLink {
                CommunityDescriptionView(communityId: communityId)
            } label: {
                Text("커뮤니티 소개")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(.gray.opacity(0.1))
            
            Spacer()
        }
        .task {
            do {
                settings = try await WebService.webService.getCommunitySettings(communityId: communityId)!
            } catch {
                
            }
        }
    }
}

