//
//  CommunityDescriptionView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/28.
//

import Foundation
import SwiftUI
import WrappingHStack

struct CommunityDescriptionView: View {
    let communityId: Int
    @State var communityData: CommunityMetadata = CommunityMetadata(
        metadata: CommunityMetadata.Metadata(
            name: "", introduce: "", hashtags: []
        )
    )
    @State var newHashtags: [String] = []
    @State var alertPresent: Bool = false
    @State var confirmPresent: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Section("커뮤니티 이름") {
                    Text(communityData.metadata.name)
                        .font(.largeTitle)
                        .padding()
                }
                
                Section("커뮤니티 소개") {
                    TextEditor(text: $communityData.metadata.introduce)
                        .frame(height: 150, alignment: .topLeading)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                Section("기존태그") {
                    WrappingHStack(communityData.metadata.hashtags ?? []) { hashtag in
                        HStack {
                            Text(hashtag)
                            Button {
                                communityData.metadata.hashtags?.removeAll { $0 == hashtag }
                            } label: {
                                Image(systemName: "delete.left.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding()
                    }
                }
                
                
                Section("새로운태그") {
                    WrappingHStack($newHashtags) { $new in
                        HStack {
                            TextField("새로운태그", text: $new)
                                .textFieldStyle(.roundedBorder)
                            Button {
                                newHashtags.removeAll { $0 == new }
                            } label: {
                                Image(systemName: "delete.left.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            if (communityData.metadata.hashtags?.count ?? 0) + newHashtags.count < 5 {
                                newHashtags.append(String(""))
                            } else {
                                alertPresent = true
                            }
                        } label: {
                            Text("태그 추가")
                                .padding(8)
                                .background(.green)
                                .cornerRadius(15)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .alert("태그 5개 초과", isPresented: $alertPresent) { }
                    }
                    
                    
                }
                
            }
            
            Button {
                Task {
                    if (communityData.metadata.hashtags == nil) {
                        communityData.metadata.hashtags = []
                    }
                    communityData.metadata.hashtags?.append(contentsOf: newHashtags)
                    try await WebService.webService.patchCommunityMetadata(communityId: communityId, communityData: communityData)
                    newHashtags.removeAll()
                    confirmPresent = true
                }
            } label: {
                Text("수정하기")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .foregroundColor(.white)
            }
            .alert("수정되었습니다", isPresented: $confirmPresent) { }
            
            Spacer()
        }
        .task {
            do {
                communityData = try await WebService.webService.getCommunityMetadata(communityId: communityId)
            } catch {
            }
        }
        .navigationTitle("커뮤니티 소개 수정")
        .animation(.default, value: [newHashtags.count, communityData.metadata.hashtags?.count])
    }
}

// Helper Extension
extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
