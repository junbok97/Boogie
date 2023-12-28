//
//  NameEnum.swift
//  Boogi
//
//  Created by 이준복 on 2022/06/02.
//

import Foundation

enum NameType {
    case like, postLikeList, commentLikeList, postDelete, commentDelete, moveToProfile, reComment
    
    func toString() -> String {
        switch self {
        case .like:
            return "Like"
        case .postLikeList:
            return "PostLikeList"
        case .commentLikeList:
            return "CommentLikeList"
        case .postDelete:
            return "PostDelete"
        case .commentDelete:
            return "CommentDelete"
        case .moveToProfile:
            return "MoveToProfile"
        case .reComment:
            return "ReComment"
            
        }
    }
}
