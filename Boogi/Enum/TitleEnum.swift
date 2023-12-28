//
//  TitleEnum.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/29.
//

import Foundation

enum TitleType {
    case notice, post, comment, profile, home, hotPost, alarm, memberList, myCommunityList, likeList, deleteCommet
    
    func toString() -> String {
        switch self {
        case .notice:
            return "공지사항"
        case .post:
            return "게시글"
        case .comment:
            return "댓글"
        case .profile:
            return "프로필"
        case .home:
            return "부기온앤온"
        case .hotPost:
            return "핫한게시물"
        case .alarm:
            return "알람"
        case .memberList:
            return "멤버목록"
        case .likeList:
            return "좋아요 목록"
        case .myCommunityList:
            return "내가 가입한 커뮤니티"
        case .deleteCommet:
            return "삭제된 댓글입니다."
        }
    }
}
