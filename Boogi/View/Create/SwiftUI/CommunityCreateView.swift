//
//  ContentView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/03/18.
//

import SwiftUI
import WrappingHStack

struct CommunityCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State var communityInfo = CreateCommunity()
    @State var alertPresent = false
    @State var confirmPresent = false
    @State var cantCreate = false
    @State var newTag = false
    @State var tag = ""
    let categoryList = ["학사", "동아리", "취미", "기타"]
    
    var body: some View {
        VStack {
            Form {
                Section("카테고리") {
                    Picker("카테고리", selection: $communityInfo.category) {
                        ForEach(CommunityCategory.allCases.filter { $0 != .all }, id: \.self) { category in
                            Text(category.type())
                        }
                    }
                }
                
                Section("커뮤니티 이름") {
                    TextField("커뮤니티 이름", text: $communityInfo.name)
                }
                
                Section("커뮤니티 소개") {
                    TextField("커뮤니티 소개", text: $communityInfo.description)
                        .frame(height: 150, alignment: .topLeading)
                }
                
                WrappingHStack($communityInfo.hashtags, id: \.self) { $hashtag in
                    HStack {
                        TextField("새로운 태그", text: $hashtag) { }
                            .textFieldStyle(.roundedBorder)
                        Button {
                            communityInfo.hashtags.removeAll { $0 == hashtag }
                        } label: {
                            Image(systemName: "delete.left.fill")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .animation(.default, value: communityInfo.hashtags.count)
                
                HStack {
                    Spacer()
                    Button {
                        if communityInfo.hashtags.count < 5 {
                            communityInfo.hashtags.append("")
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
                
                Section("추가 설정") {
                    Button {
                        communityInfo.isPrivate.toggle()
                    } label: {
                        HStack {
                            Image(systemName: communityInfo.isPrivate ? "checkmark.square.fill" : "square")
                            Text("비공개")
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Button {
                        communityInfo.autoApproval.toggle()
                    } label: {
                        HStack {
                            Image(systemName: communityInfo.autoApproval ? "checkmark.square.fill" : "square")
                            Text("자동가입승인")
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                    .padding()
                }
                
                Button {
                    Task {
                        do {
                            if (communityInfo.name == "" ||
                                communityInfo.description == "") {
                                cantCreate = true
                                return
                            }
                            communityInfo.hashtags.removeAll { $0 == "" }
                            try await WebService.webService.createCommunity(communityInfo: communityInfo)
                            confirmPresent = true
                            dismiss()
                        } catch {
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("생성하기")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .alert("이름이나 설명을 입력해주세요", isPresented: $cantCreate) { }
                .alert("생성되었습니다", isPresented: $confirmPresent) { }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
