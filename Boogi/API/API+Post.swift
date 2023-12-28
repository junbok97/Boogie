//
//  API+Post.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/29.
//

import Foundation
import Alamofire

extension WebService {
    

    func createPost(form: CreatePost) async throws -> Void {
        guard let url = URL(string: "\(base)/posts/") else { return }
        
        let body = try JSONEncoder().encode(form)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    
    func getPostDetail(postId: Int) async throws -> PostDetail? {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/posts/\(postId)") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let postDetail = try JSONDecoder().decode(PostDetail.self, from: data)
        
        return postDetail
    }
    
    func getPostDetail2(postId: Int, completionHandler: @escaping (Post?) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getPostDetail2(postId: postId, completionHandler: completionHandler)
        }

        AF.request("\(self.base)/posts/\(postId)", method: .get,  headers: self.tokenheader).responseDecodable(of: Post.self) { (response) in
            guard let post = response.value else {return}
            completionHandler(post)
        }
    }
    
    func deletePost(postId: Int, completionHandler: @escaping (ServerMessage?) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.deletePost(postId: postId, completionHandler: completionHandler)
        }
        AF.request("\(self.base)/posts/\(postId)", method: .delete,  headers: self.tokenheader)
            .responseDecodable(of: ServerMessage.self) { response in
                completionHandler(response.value)
//                switch response.response?.statusCode {
//                case 200:
//                    completionHandler(nil)
//                default :
//                    guard let serverMessage = response.value else {return}
//                    completionHandler(serverMessage)
//                }
            }
                    
            
            
//            .response {response in
//            switch response.result {
//            case .success(let data):
//                switch response.response?.statusCode {
//                case 200:
//                    completionHandler("게시글이 삭제되었습니다.")
//                default:
//                    let serverMessage = try! JSONDecoder().decode(ServerMessage.self, from: data!)
//                    completionHandler(serverMessage.message)
//
//                }
//            case .failure(let error):
//                print("Delete Post NetWork Error : \(error)")
//            }
//        }
        
        

        
//            .responseData { response in
//            print(response)
//            switch response.result {
//            case .success(let data):
//                guard let response = response.response else {return}
//                switch response.statusCode {
//                case 200 :
//                    completionHandler("게시글이 삭제되었습니다")
//                default:
//                    let json = try? JSONSerialization.jsonObject(with: data)
//                    if let json = json as? [String: Any], let message = json["message"] as? String {completionHandler(message)}
//                }
//            case .failure(let error):
//                print("Delete Post NetWork Error : \(error)")
//            }
//        }
    }
    
    
    func getHotPosts(completionHandler: @escaping ([HotPost]?) -> ()) {
        getToken2() { [weak self] in
            guard let self = self else {return}
            self.getHotPosts(completionHandler: completionHandler)
        }

        AF.request("\(self.base)/posts/hot", method: .get,  headers: self.tokenheader).responseDecodable(of: [String :[HotPost]].self) { (response) in
            guard let json = response.value else {return}
            let hots = json["hots"]
            completionHandler(hots)
        }
    }
    
  
    
    
}
