//
//  CommunitySearchResult.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/23.
//

import Foundation
import SwiftUI

struct CommunitySearchResultView: View {
    @Binding var searchParams: SearchParameter
    
    @Binding var res: CommunitySearchResult?
    @Binding var communities: [CommunitySearchResult.Community]
    @State var alertPresent = false
    @State var confirmPresent = false
    @State var errorMessage = ""
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(communities, id: \.self) { community in
                    NavigationLink {
                        CommunityHomeLink(communityId: community.id)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        Task {
                                            do {
                                                let _ = try await WebService.webService.postJoinRequests(communityId: community.id)
                                                confirmPresent = true
                                            } catch (let err as APIError) {
                                                errorMessage = err.message
                                                alertPresent = true
                                            }
                                        }
                                    } label: {
                                        Text("가입")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .alert(errorMessage, isPresented: $alertPresent) { }
                            .alert("가입신청되었습니다", isPresented: $confirmPresent) { }
                    } label: {
                        CommunityResult(community: community)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                }
                .padding()
                
                if (res?.pageInfo.hasNext) ?? true {
                    ProgressView()
                        .padding()
                        .task {
                            do {
                                res = try await WebService.webService.getCommunitiesSearch(
                                    searchParams: searchParams, nextPage: res?.pageInfo.nextPage ?? 0
                                )
                                communities.append(contentsOf: res?.communities ?? [])
                            } catch {
                                res?.pageInfo.hasNext = false
                            }
                        }
                }
                
                if communities.isEmpty {
                    Text("결과가 없습니다.")
                }
            }
        }
    }
}

struct CommunityHomeLink: UIViewControllerRepresentable {
    let communityId: Int
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = ViewControllerFactory.viewControllerFactory.makeViewController(controllerType: .communityHome, id: communityId)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
