//
//  API+Like.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/27.
//

import Foundation
import Alamofire

extension WebService {
    
    func postLike(id postId: Int, completionHandler: @escaping (PostSuccess) -> ()) {
        getToken2() { [weak self] in
            guard let self = self else {return}
            self.postLike(id: postId, completionHandler: completionHandler)
        }

        AF.request("\(self.base)/posts/\(postId)/likes", method: .post, headers: tokenheader).responseDecodable(of: PostSuccess.self) { response in
            guard let like = response.value else {return}
            completionHandler(like)
        }
    }
    
    func getPostLikeList(id postId: Int, of page: Int, size: Int, completionHandler: @escaping (LikeList) -> ()){
        getToken2() { [weak self] in
            guard let self = self else {return}
            self.getPostLikeList(id: postId, of: page, size: size, completionHandler: completionHandler)
        }

        let param = ["page" : page, "size" : size]
        AF.request("\(self.base)/posts/\(postId)/likes", method: .get, parameters: param ,headers: tokenheader)
            .responseDecodable(of: LikeList.self) { response in
                guard let likeList = response.value else {return}
                completionHandler(likeList)
            }
    }
    
    func commentLike(id commentId: Int, completionHandler: @escaping (PostSuccess) -> ()) {
    
        getToken2() { [weak self] in
            guard let self = self else {return}
            self.commentLike(id: commentId, completionHandler: completionHandler)
        }

        AF.request("\(self.base)/comments/\(commentId)/likes", method: .post, headers: tokenheader).responseDecodable(of: PostSuccess.self) { response in
            guard let like = response.value else {return}
            completionHandler(like)
        }
    }
    
    func getCommentLikeList(id commentId: Int, of page: Int, size: Int, completionHandler: @escaping (LikeList) -> ()){
        
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getCommentLikeList(id: commentId, of: page, size: size, completionHandler: completionHandler)
        }

        let param = ["page" : page, "size" : size]
        AF.request("\(self.base)/comments/\(commentId)/likes", method: .get, parameters: param ,headers: tokenheader)
            .responseDecodable(of: LikeList.self) { response in
                guard let likeList = response.value else {return}
                completionHandler(likeList)
            }
    }
    
    func deleteLike(id likeId: Int, completionHandler: @escaping () -> ()) {
        getToken2() { [weak self] in
            guard let self = self else {return}
            self.deleteLike(id: likeId, completionHandler: completionHandler)
        }
        
        AF.request("\(self.base)/likes/\(likeId)", method: .delete, headers: tokenheader).response { _ in
            completionHandler()
        }
    }

}
