//
//  CellFactroy.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/25.
//

import Foundation
import UIKit

class CellFactory {
    
    static let cellFactory = CellFactory()
    
    func makeCell(cellType: CellType, data: Any?, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch(cellType) {
        case .reComment:
            let comment = data as? Comment
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.toString(), for: indexPath) as! ReCommentCell
            cell.configure(with: comment)
            return cell
        case .profile:
            let user = data as? User
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.toString(), for: indexPath) as! ProfileCell
            cell.configure(user: user!)
            return cell
        case .communityList:
            let community = data as? JoinCommunity.Community
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.toString(), for: indexPath) as! CommunityListCell
            cell.configure(community: community)
            return cell
        case .comment:
            let comment = data as? Comment
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.toString(),for: indexPath) as! CommentCell
            cell.configure(with: comment)
            return cell
        case .likeList:
            let user = data as? LikeList.User
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.toString(), for: indexPath) as! LikeListCell
            cell.configure(user: user!)
            return cell
        case .hotList:
            let hotPost = data as? HotPost
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.toString(), for: indexPath) as! HotListCell
            cell.configure(with: hotPost)
            return cell
        case .memberList:
            let member = data as? Member
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.toString(), for: indexPath) as! MemberListCell
            cell.configure(member: member)
            return cell
        case .post :
            let post = data as? Post
            if post?.postMedias == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellType.postText.toString(),for: indexPath) as! PostTextCell
                cell.configure(with: post)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellType.post.toString(),for: indexPath) as! PostCell
                cell.configure(with: post)
                return cell
            }
        case .profilePost :
            let profile = data as? Profile
            if profile?.post?.postMedias == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellType.profilePostText.toString(), for: indexPath) as! ProfilePostTextCell
                cell.configure(profile: profile)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellType.profilePost.toString(), for: indexPath) as! ProfilePostCell
                cell.configure(profile: profile)
                return cell
            }
        case .profileComment :
            let profile = data as? Profile
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.toString(), for: indexPath) as! ProfileCommentCell
            cell.configure(profile: profile)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
