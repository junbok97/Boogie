//
//  ViewController.swift
//  Test
//
//  Created by 이준복 on 2022/05/03.
//

import UIKit
import SnapKit
import Kingfisher

class HomeViewController: UIViewController {
    
    let webSevice = WebService.webService
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    let cellFactory = CellFactory.cellFactory
    let vcFactory = ViewControllerFactory.viewControllerFactory
    let headerViewFactory = HeaderViewFactory.headerViewFactory
    
    var notices: [Notice]?
    var hots: [HotPost]?
    var joinCommunityList: [JoinCommunity.Community]?

    @IBOutlet weak var HomeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TitleType.home.toString()
        navigationItem.backButtonTitle = ""
        tableViewSetting()
        api()
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        api()
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotification()
    }
    
    
}

extension HomeViewController {
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveToCommunityHomeView(_:)), name: NSNotification.Name("HomeMoveCommunityHome"), object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func moveToCommunityHomeView(_ notification: Notification) {
        guard let communityId = notification.userInfo?["communityId"] as? Int else {return}
        let vc = vcFactory.makeViewController(controllerType: .communityHome, id: communityId)
        navigationController?.pushViewController(vc, animated: true)
    }


}

extension HomeViewController {
    func tableViewSetting() {
        HomeTableView.dataSource = self
        HomeTableView.delegate = self
        HomeTableView.rowHeight = UITableView.automaticDimension
        HomeTableView.register(UINib(nibName: CellType.headerButton.toString(), bundle: nil), forHeaderFooterViewReuseIdentifier: CellType.headerButton.toString())
        HomeTableView.register(UINib(nibName: CellType.baseList.toString(), bundle: nil), forCellReuseIdentifier: CellType.baseList.toString())
        HomeTableView.register(UINib(nibName: CellType.hotList.toString(), bundle: nil), forCellReuseIdentifier: CellType.hotList.toString())
        HomeTableView.register(UINib(nibName: CellType.communityList.toString(), bundle: nil), forCellReuseIdentifier: CellType.communityList.toString())
    }
}

extension HomeViewController {
    func api(){
        webSevice.getRecentNotices(communityId: nil) { [weak self] notices in
            guard let self = self else {return}
            self.notices = notices
            self.HomeTableView.reloadData()
        }
        
        webSevice.getHotPosts { [weak self] hots in
            guard let self = self else {return}
            self.hots = hots
            self.HomeTableView.reloadData()
        }
        
        webSevice.getJoinCommunityList { [weak self] joinCommunity in
            guard let self = self else {return}
            self.joinCommunityList = joinCommunity?.communities
            self.HomeTableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            // 공지사항 셀의 개수
        case 0:
            return notices?.count ?? 0
            // 핫한 게시물 셀의 개수
        case 1:
            return hots?.count ?? 0
            // 내가 가입한 커뮤니티 셀의 개수
        case 2:
            return joinCommunityList?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            // 공지사항 셀
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellType.baseList.toString(), for: indexPath) as! BaseListCell
            cell.configure(dataType: .notice, data: notices?[indexPath.row])
            return cell
            // 핫한게시물 셀
        case 1:
            return cellFactory.makeCell(cellType: .hotList, data: hots?[indexPath.row], tableView: tableView, indexPath: indexPath)
            
            // 내가 가입한 커뮤니티 셀
        default:
            return cellFactory.makeCell(cellType: .communityList, data: joinCommunityList?[indexPath.row], tableView: tableView, indexPath: indexPath)
        }
    }
    
    // 셀을 선택했을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
            // 공지사항 상세
        case 0:
            let vc = vcFactory.makeViewController(controllerType: .noticeList, id: nil)
            navigationController?.pushViewController(vc, animated: true)
            // 핫한게시물 상세
        case 1:
            let vc = vcFactory.makeViewController(controllerType: .postDetail, id: hots?[indexPath.row].postId)
            navigationController?.pushViewController(vc, animated: true)
            // 커뮤니티 게시글 목록
        default:
            let vc = vcFactory.makeViewController(controllerType: .postList, id: joinCommunityList?[indexPath.row].id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 2:
            return UITableView.automaticDimension
        default:
            return CGFloat(height.base.rawValue)
        }
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(height.defaultSectionHeader.rawValue)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // 헤더 만들기
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            // 공지사항
        case 0:
            return headerViewFactory.makeHeaderView(headertype: .title, title: .notice)
//            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellType.headerButton.toString()) as? HeaderButton else {return UIView()}
//            headerView.configure(title: .notice, navigationController: self.navigationController, controllerType: .noticeList, id: nil)
//            return headerView
            // 핫한게시물
        case 1:
            return headerViewFactory.makeHeaderView(headertype: .title, title: .hotPost)
            // 내가 가입한 커뮤니티 리스트
        default:
            return headerViewFactory.makeHeaderView(headertype: .title, title: .myCommunityList)
        }
    }
    
}
