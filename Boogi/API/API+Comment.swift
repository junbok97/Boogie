//
//  API+Comment.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/23.
//

import Foundation
import Alamofire

extension WebService {
    func getComments(postId: Int, page: Int, size: Int, completionHandler: @escaping (Comments) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getComments(postId: postId, page: page, size: size, completionHandler: completionHandler)
        }
        
        let param = ["page" : page, "size" : size]
        print(param)
        AF.request("\(self.base)/posts/\(postId)/comments", method: .get, parameters: param ,headers: tokenheader)
            .responseDecodable(of: Comments.self) { response in
                guard let comments = response.value else {return}
                completionHandler(comments)
            }
    }
    
    

    func createComment(comment: CreatedComment, completionHandler: @escaping () -> ()) {
        getToken2 { [weak self] in
            guard let self = self else {return}
            self.createComment(comment: comment, completionHandler: completionHandler)
        }
        
        
        AF.request("\(self.base)/comments/", method: .post, parameters: comment,encoder: .json, headers: tokenheader).responseDecodable(of: PostSuccess.self) { response in
            completionHandler()
        }
    }
    
    func deleteComment(commentId: Int, completionHandler: @escaping (ServerMessage?) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.deleteComment(commentId: commentId, completionHandler: completionHandler)
        }
        AF.request("\(self.base)/comments/\(commentId)", method: .delete,  headers: self.tokenheader)
            .responseDecodable(of: ServerMessage.self) { response in
                completionHandler(response.value)
            }
    }
    
}
