//
//  ViewControllerFactory.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/18.
//

import UIKit

class ViewControllerFactory {
    
    static let viewControllerFactory = ViewControllerFactory()

    func makeViewController(controllerType: ControllerType, id: Int?) -> UIViewController {
        switch controllerType {
        case .profile:
            let storyBoard = UIStoryboard(name: ControllerType.profile.toString(), bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: ControllerType.profile.toString()) as! ProfileViewController
            vc.configure(userId: id)
            return vc
        case .communityHome:
            let storyBoard = UIStoryboard(name: ControllerType.communityHome.toString(), bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: ControllerType.communityHome.toString()) as! CommunityHomeViewController
            vc.configure(id: id!)
            return vc
        case .likeListType(let listType):
        let vc = LikeListViewController(nibName: ControllerType.likeList.toString(), bundle: nil)
            vc.configure(listType: listType, id: id!)
            return vc
        case .noticeList :
            let vc = NoticeListViewController(nibName: controllerType.toString(), bundle: nil)
            vc.configure(id: id)
            return vc
        case .postList :
            let vc = PostListViewController(nibName: controllerType.toString(), bundle: nil)
            vc.configure(id: id!)
            return vc
        case .postDetail :
            let vc = PostDetailViewController(nibName: controllerType.toString(), bundle: nil)
            vc.configure(id: id!)
            return vc
        case .memberList :
            let vc = MemberListViewController(nibName:controllerType.toString(), bundle: nil)
            vc.configure(id: id!)
            return vc
        default :
            let vc = UIViewController()
            return vc
        }
    }

}
