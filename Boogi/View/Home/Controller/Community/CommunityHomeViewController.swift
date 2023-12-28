//
//  CommunityHomeViewController.swift
//  Test
//
//  Created by 이준복 on 2022/05/06.
//

import UIKit
import SwiftUI

class CommunityHomeViewController: UIViewController {
    
    @IBOutlet weak var communityHomeTableView: UITableView!
    
    let webService = WebService.webService
    let vcFactory = ViewControllerFactory.viewControllerFactory
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var communityId: Int?
    var communityDetail: CommunityDetail2?
    var recentNotices: [Notice]?
    var recentPosts: [Post]?
    var sessionMemberType: MemberType? = .outsider {
        didSet {
            settingRightBarButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetting()
        api()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        api()
    }

    @IBAction func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        
        switch sessionMemberType {
        case .normal:
            return
        case .outsider:
            webService.postJoinCommunity(communityId: communityId!) { [weak self] requestJoinCommunity in
                guard let self = self else {return}
                if requestJoinCommunity.requestId != nil {
                    let alertController = UIAlertController(title: "가입 신청 완료", message: nil, preferredStyle: .alert)
                    self.present(alertController, animated: true)
                } else {
                    let alertController = UIAlertController(title: "가입 신청 완료", message: requestJoinCommunity.servermessage?.message, preferredStyle: .alert)
                    self.present(alertController, animated: true)
                }
            }
        default :
            let vc = UIHostingController(rootView: CommunitySettingView(communityId: communityId!))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension CommunityHomeViewController {
    
    func configure(id: Int){
        communityId = id
        api()
    }
    
    func settingVC() {
        guard let communityDetail = communityDetail else {return}
        navigationItem.title = communityDetail.community.name
        navigationItem.backButtonTitle = ""
        recentNotices = communityDetail.notices
        recentPosts = communityDetail.posts
        communityHomeTableView.reloadData()
        if let type = communityDetail.sessionMemberType {
            sessionMemberType = MemberType(rawValue: type)
        } else {sessionMemberType = .outsider}
    }
    
    func settingRightBarButton() {
        switch sessionMemberType {
        case .outsider :
            rightBarButton.title = "가입"
            rightBarButton.image = nil
        case .normal :
            rightBarButton.title = ""
            rightBarButton.image = nil
        default :
            rightBarButton.title = "커뮤니티 설정"
            rightBarButton.image = UIImage(systemName: "gearshape")
        }
    }

}


// api()
extension CommunityHomeViewController {
    func api() {
        webService.getCommunityDetail2(communityId: communityId!) { [weak self] communityDetail in
            guard let self = self else {return}
            
            self.communityDetail = communityDetail
            self.settingVC()
        }
    }
}

extension CommunityHomeViewController {
    func tableViewSetting() {
        communityHomeTableView.delegate = self
        communityHomeTableView.dataSource = self
        communityHomeTableView.rowHeight = UITableView.automaticDimension
        communityHomeTableView.register(UINib(nibName: CellType.headerButton.toString(), bundle: nil), forHeaderFooterViewReuseIdentifier: CellType.headerButton.toString())
        communityHomeTableView.register(UINib(nibName: CellType.baseList.toString(), bundle: nil), forCellReuseIdentifier: CellType.baseList.toString())
        communityHomeTableView.register(UINib(nibName: CellType.communityInfo.toString(), bundle: nil), forCellReuseIdentifier: CellType.communityInfo.toString())
    }
}



extension CommunityHomeViewController: UITableViewDelegate,UITableViewDataSource{
    // 섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    // 섹션별 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            // 공지사항 섹션
        case 1:
            return recentNotices?.count ?? 0
            // 게시물 섹션
        case 2:
            return recentPosts?.count ?? 0
        default:
            return 0
            
        }
    }
    
    // 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            // 커뮤니티 설명
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellType.communityInfo.toString(), for: indexPath) as! CommunityInfoCell
            cell.configure(communityId: self.communityId ,communityDetail: self.communityDetail, navigationVC: navigationController)
            return cell
            // 공지사항
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellType.baseList.toString(), for: indexPath) as! BaseListCell
            cell.configure(dataType: .notice, data: recentNotices?[indexPath.row])
            return cell
            // 최근 게시물
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellType.baseList.toString(), for: indexPath) as! BaseListCell
            cell.configure(dataType: .post, data: communityDetail?.posts?[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // 셀을 선택했을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            // 공지사항 리스트
        case 1:
            let vc = vcFactory.makeViewController(controllerType: .noticeList, id: communityId)
            navigationController?.pushViewController(vc, animated: true)
            // 게시글 상세
        case 2:
            let vc = vcFactory.makeViewController(controllerType: .postDetail, id: recentPosts?[indexPath.row].id)
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    // 섹션 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            // 공지사항 섹션
        case 1:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellType.headerButton.toString()) as! HeaderButton
            headerView.configure(title: .notice, navigationController: self.navigationController, controllerType: .noticeList, id: self.communityId)
            return headerView
            // 게시물 섹션
        case 2:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellType.headerButton.toString()) as! HeaderButton
            headerView.configure(title: .post, navigationController: self.navigationController, controllerType: .postList, id: self.communityId)
            return headerView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default :
            return CGFloat(height.defaultSectionHeader.rawValue)
        }
    }
    
}
