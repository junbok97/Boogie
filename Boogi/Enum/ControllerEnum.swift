//
//  ControllerEnum.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/29.
//

import Foundation

enum DataType {
    case post, notice, comment, profile
}

enum ListType {
    case post, comment
}


enum ControllerType{
    case noticeList, communityNotice, postDetail, postList, communityHome, memberList, likeList, profile
    
    case likeListType(ListType)
    
    func toString() -> String {
        switch self {
        case .profile:
            return "ProfileViewController"
        case .noticeList:
            return "NoticeListViewController"
        case .communityNotice:
            return "NoticeDetailViewController"
        case .postDetail:
            return "PostDetailViewController"
        case .postList:
            return "PostListViewController"
        case .communityHome:
            return "CommunityHomeViewController"
        case .memberList:
            return "MemberListViewController"
        case .likeList:
            return "LikeListViewController"
        default :
            return ""
        }
    }
}
