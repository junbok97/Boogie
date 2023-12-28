//
//  CreateView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/05.
//

import Foundation
import SwiftUI
import WrappingHStack
import PhotosUI

struct PostCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State var joinedCommunities: JoinedCommunity = JoinedCommunity(communities: [])
    @State var createPost = CreatePost()
    @State var alertPresent = false
    @State var confirmPresent = false
    @State var isProgressing = false
    @State var selected = JoinedCommunity.Community(name: "", id: -1)
    @State var images: [UIImage] = []
    @State var isPicking = false
    
    var body: some View {
        ZStack {
            Form {
                Section("커뮤니티 선택") {
                    Picker("커뮤니티 선택", selection: $selected) {
                        ForEach(joinedCommunities.communities, id: \.self) { community in
                            Text(community.name)
                        }
                    }
                }
                
                Section("글") {
                    TextEditor(text: $createPost.content)
                        .frame(height: 150, alignment: .topLeading)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                Section("태그") {
                    WrappingHStack($createPost.hashtags) { $new in
                        HStack {
                            TextField("새로운태그", text: $new)
                                .textFieldStyle(.roundedBorder)
                            Button {
                                createPost.hashtags.removeAll { $0 == new }
                            } label: {
                                Image(systemName: "delete.left.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .animation(.default, value: createPost.hashtags.count)
                    
                    HStack {
                        Spacer()
                        Button {
                            if createPost.hashtags.count < 5 {
                                createPost.hashtags.append(String(""))
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
                
                Section("사진") {
                    HStack {
                        ForEach(images, id: \.self) { img in
                            Image(uiImage: img)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                        Button {
                            isPicking = true
                        } label: {
                            Text("Image")
                        }
                    }
                    .sheet(isPresented: $isPicking) {
                        ImagePicker(isPicking: $isPicking, images: $images)
                    }
                }
                
                Button {
                    Task {
                        do {
                            createPost.hashtags.removeAll { $0 == "" }
                            createPost.communityId = selected.id
                            isProgressing = true
                            
                            createPost.postMediaIds = try await WebService.webService.createPostwithImage(images: images)
                            
                            try await WebService.webService.createPost(form: createPost)
                            
                            isProgressing = false
                            confirmPresent = true
                            dismiss()
                        } catch {
                            isProgressing = false
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
                .alert("생성되었습니다", isPresented: $confirmPresent) { }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .fullScreenCover(isPresented: $isProgressing) {
            PostProgressView()
        }
        .task {
            do {
                joinedCommunities = try await WebService.webService.getJoinedCommunity()
            } catch {
                
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPicking: Bool
    @Binding var images: [UIImage]
    
    class Coordinator: PHPickerViewControllerDelegate {
        let picker: ImagePicker
        init(picker: ImagePicker) {
            self.picker = picker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.picker.isPicking = false
            
            self.picker.images.removeAll()
            for img in results {
                if img.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    img.itemProvider.loadObject(ofClass: UIImage.self) { loadedImg, error in
                        guard let loadedImg = loadedImg else {
                            return
                        }
                        
                        self.picker.images.append(loadedImg as! UIImage)
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(picker: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var pickerConfig = PHPickerConfiguration()
        pickerConfig.selectionLimit = 3
        pickerConfig.filter = .images
        
        let picker = PHPickerViewController(configuration: pickerConfig)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
