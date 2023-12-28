//
//  ProfileViewController.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/14.
//

import UIKit
import SwiftUI
import Kingfisher

class ProfileViewController: UIViewController {


    @IBOutlet weak var listTableView: UITableView!
    
    let webService = WebService.webService
    let cellFactory = CellFactory.cellFactory
    let vcFactory = ViewControllerFactory.viewControllerFactory
    
    // 조회할 유저의 아이디
    var userId: Int!
    
    var listType = ListType.post {
        didSet{
            getList()
            listTableView.reloadData()
        }
    }
    
    var profile: Profile?
    var postList = [ProfilePost]()
    var commentList = [ProfileComment]()
    
    var postCurrentPage = 0
    var postHasNext: Bool = true
    
    var commentCurrentPage = 0
    var commentHasNext: Bool = true
    
    var size = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TitleType.profile.toString()
        navigationItem.backButtonTitle = ""
        tableViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        api()
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotification()
    }
    

    @IBSegueAction func addSwiftUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: MessageDetailView(opponentId: userId!))
    }
    
    @IBAction func listType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.listType = .post
        default:
            self.listType = .comment
        }
    }
    
 
}

extension ProfileViewController {
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveToCommunityHome(_:)), name: NSNotification.Name("ProfileMoveCommunityHome"), object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func moveToCommunityHome(_ notification: Notification) {
        guard let communityId = notification.userInfo?["communityId"] as? Int else {return}
        let vc = vcFactory.makeViewController(controllerType: .communityHome, id: communityId)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ProfileViewController {
    
    func configure(userId: Int?) {
        self.userId = userId
    }
    

}

// api
extension ProfileViewController {
    
    func valueInit() {
        postHasNext = true
        postCurrentPage = 0
        postList.removeAll()
        commentHasNext = true
        commentCurrentPage = 0
        commentList.removeAll()
    }
    
    func api() {
        webService.getUserProfile(userId: userId) { [weak self] profile in
            guard let self = self else {return}
            self.profile = profile
            self.userId = profile.user.id
        }
        valueInit()
        getList()
    }
    
    func getList() {

        switch listType {
        case .post:
            getPost()
        case .comment:
            getComment()
        }
    }
    
    func getPost() {
        if postHasNext {
            webService.getUserPostList(userId: userId, page: postCurrentPage, size: size) { [weak self] posts in
                guard let self = self else {return}
                if self.postCurrentPage >= posts.pageInfo.nextPage {
                    return
                }
                self.postHasNext = posts.pageInfo.hasNext
                self.postCurrentPage = posts.pageInfo.nextPage
                self.postList += posts.posts
                self.listTableView.reloadData()
            }
        }
    }
    
    func getComment() {
        if commentHasNext {
            webService.getUserCommentList(userId: userId, page: commentCurrentPage, size: size) { [weak self] comments in
                guard let self = self else {return}
                if self.commentCurrentPage >= comments.pageInfo.nextPage {
                    return
                }
                self.commentCurrentPage = comments.pageInfo.nextPage
                self.commentHasNext = comments.pageInfo.hasNext
                self.commentList += comments.comments
                self.listTableView.reloadData()
            }

        }
    }
    
}

// talbeView
extension ProfileViewController {
    func tableViewSetting() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.prefetchDataSource = self
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.register(UINib(nibName: CellType.profile.toString(), bundle: nil), forCellReuseIdentifier: CellType.profile.toString())
        listTableView.register(UINib(nibName: CellType.profilePost.toString(), bundle: nil), forCellReuseIdentifier: CellType.profilePost.toString())
        listTableView.register(UINib(nibName: CellType.profilePostText.toString(), bundle: nil), forCellReuseIdentifier: CellType.profilePostText.toString())
 
        listTableView.register(UINib(nibName: CellType.profileComment.toString(), bundle: nil), forCellReuseIdentifier: CellType.profileComment.toString())
        
        
    }
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default :
            switch listType {
            case .post:
                return postList.count
            case .comment:
                return commentList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 1:
            var id: Int?
            switch listType {
            case .post:
                id = postList[indexPath.row].id
            case .comment:
                id = commentList[indexPath.row].postId
            }
            let vc = vcFactory.makeViewController(controllerType: .postDetail, id:id)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var profile = profile else { return UITableViewCell()}
        
        
        switch indexPath.section {
        case 0:
            return cellFactory.makeCell(cellType: .profile, data: profile.user, tableView: tableView, indexPath: indexPath)
        default:
            switch listType {
            case .post:
                profile.post = postList[indexPath.row]
                return cellFactory.makeCell(cellType: .profilePost, data: profile, tableView: tableView, indexPath: indexPath)
            case .comment:
                profile.comment = commentList[indexPath.row]
                return cellFactory.makeCell(cellType: .profileComment, data: profile, tableView: tableView, indexPath: indexPath)
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        switch listType {
        case .post:
            if postHasNext && postCurrentPage != 0 {
                indexPaths.forEach {
                    if ($0.row + 1) / size + 1 == postCurrentPage {
                        self.getPost()
                    }
                }
            }
        case .comment:
            if commentHasNext && commentCurrentPage != 0 {
                indexPaths.forEach {
                    if ($0.row + 1) / size + 1 == commentCurrentPage {
                        self.getComment()
                    }
                }
            }
        }
    }
}

//
////
////  ProfileViewController.swift
////  Boogi
////
////  Created by 이준복 on 2022/05/14.
////
//
//import UIKit
//import SwiftUI
//import Kingfisher
//
//class ProfileViewController: UIViewController {
//
//
//    @IBOutlet weak var userNameLabel: UILabel!
//    @IBOutlet weak var userTagLabel: UILabel!
//    @IBOutlet weak var userIntroduce: UILabel!
//    @IBOutlet weak var userDepartmentLabel: UILabel!
//    @IBOutlet weak var userProfileImageView: UIImageView!
//    @IBOutlet weak var listTableView: UITableView!
//
//    let webService = WebService.webService
//    let cellFactory = CellFactory.cellFactory
//    let vcFactory = ViewControllerFactory.viewControllerFactory
//
//    // 조회할 유저의 아이디
//    var userId: Int?
//
//    var listType = ListType.post
//
//    var profile: Profile?
//    var postList: [ProfilePost]?
//    var commentList: [ProfileComment]?
//    var currentPage = 0
//    var size = 10
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = TitleType.profile.toString()
//        navigationItem.backButtonTitle = ""
//        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
//        api()
//        tableViewSetting()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(moveToCommunityHome(_:)), name: NSNotification.Name("ProfileMoveCommunityHome"), object: nil)
//    }
//
//    @objc func moveToCommunityHome(_ notification: Notification) {
//        guard let communityId = notification.userInfo?["communityId"] as? Int else {return}
//        let vc = vcFactory.makeViewController(controllerType: .communityHome, id: communityId)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        api()
//    }
//
//
//    @IBSegueAction func addSwiftUI(_ coder: NSCoder) -> UIViewController? {
//        return UIHostingController(coder: coder, rootView: MessageDetailView(opponentId: userId!))
//    }
//
//    @IBAction func listType(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            self.listType = .post
//        default:
//            self.listType = .comment
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
//
//extension ProfileViewController {
//
//    func configure(userId: Int?) {
//        self.userId = userId
//    }
//
//    func settingUserProfile() {
//        guard let user = profile?.user else {return}
//        userId = user.id
//        userNameLabel.text = user.name
//        userTagLabel.text = user.tagNum
//        userIntroduce.text = user.introduce
//        userDepartmentLabel.text = user.department
//        if let profileImageUrl = user.profileImageUrl {
//            let imageURL = URL(string: profileImageUrl)
//            userProfileImageView.kf.setImage(with: imageURL)
//            userProfileImageView.contentMode = .scaleAspectFill
//        }
//    }
//
//    func api() {
//        webService.getUserProfile(userId: userId) { [weak self] profile in
//            guard let self = self else {return}
//            print(profile)
//            self.profile = profile
//            self.settingUserProfile()
//        }
//
//        switch listType {
//        case .post:
//            webService.getUserPostList(userId: userId, page: currentPage, size: size) { [weak self] posts in
//                guard let self = self else {return}
//                self.postList = posts.posts
////                self.currentPage = posts.pageInfo.nextPage
//                self.listTableView.reloadData()
//            }
//        case .comment:
//            webService.getUserCommentList(userId: userId, page: currentPage, size: size) { [weak self] comments in
//                guard let self = self else {return}
//                self.commentList = comments.comments
////                self.currentPage = comments.pageInfo.nextPage
//                self.listTableView.reloadData()
//            }
//        }
//    }
//}
//
//// talbeView
//extension ProfileViewController {
//    func tableViewSetting() {
//        listTableView.delegate = self
//        listTableView.dataSource = self
//        listTableView.rowHeight = UITableView.automaticDimension
//        listTableView.register(UINib(nibName: CellType.profilePostType(.text).toString(), bundle: nil), forCellReuseIdentifier: CellType.profilePostType(.text).toString())
//        listTableView.register(UINib(nibName: CellType.profilePostType(.image).toString(), bundle: nil), forCellReuseIdentifier: CellType.profilePostType(.image).toString())
//        listTableView.register(UINib(nibName: CellType.profileComment.toString(), bundle: nil), forCellReuseIdentifier: CellType.profileComment.toString())
//    }
//}
//
//extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch listType {
//        case .post:
//            return postList?.count ?? 0
//        case .comment:
//            return commentList?.count ?? 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var id: Int?
//        switch listType {
//        case .post:
//            id = postList?[indexPath.row].id
//        case .comment:
//            id = commentList?[indexPath.row].postId
//        }
//        let vc = vcFactory.makeViewController(controllerType: .postDetail, id:id)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard var profile = profile else { return UITableViewCell()}
//        switch listType {
//        case .post:
//            profile.post = postList?[indexPath.row]
//            return cellFactory.makeCell(cellType: .profilePost, data: profile, tableView: tableView, indexPath: indexPath)
//        case .comment:
//            profile.comment = commentList?[indexPath.row]
//            return cellFactory.makeCell(cellType: .profileComment, data: profile, tableView: tableView, indexPath: indexPath)
//        }
//    }
//
//
//}
