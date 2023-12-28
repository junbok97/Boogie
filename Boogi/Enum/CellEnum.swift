//
//  CellEnum.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/29.
//

import Foundation

//enum PostType {
//    case text, image
//    func toString() -> String {
//        switch self {
//        case .text:
//            return "Text"
//        case .image:
//            return "Image"
//        }
//    }
//}

enum HeaderType {
    case title, comment
    

}

enum CellType {
    case hotList, baseList, appNotice, communityNotice, communityList, communityInfo, comment, memberList, headerButton, likeList, profileComment, post, profilePost, profile, reComment, postText, profilePostText
    
    
    func toString() -> String {
        switch self {
        case .profilePostText:
            return "ProfilePostTextCell"
        case .postText:
            return "PostTextCell"
        case .reComment:
            return "ReCommentCell"
        case .post:
            return "PostCell"
        case .profile:
            return "ProfileCell"
        case .profilePost:
            return "ProfilePostCell"
        case .profileComment:
            return "ProfileCommentCell"
        case .hotList:
            return "HotListCell"
        case .baseList:
            return "BaseListCell"
        case .appNotice:
            return "AppNoticeCell"
        case .communityNotice:
            return "CommunityNoticeCell"
        case .communityList:
            return "CommunityListCell"
        case .communityInfo:
            return "CommunityInfoCell"
        case .comment:
            return "CommentCell"
        case .memberList:
            return "MemberListCell"
        case .headerButton:
            return "HeaderButton"
        case .likeList:
            return "LikeListCell"
        }
    }
}
