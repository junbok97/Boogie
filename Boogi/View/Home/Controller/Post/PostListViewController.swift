//
//  ViewController.swift
//  boogi_comunity
//
//  Created by 이준복 on 2022/03/31.
//

import UIKit

class PostListViewController: UIViewController {
    

    @IBOutlet weak var postListTableView: UITableView!
    
    let cellFactory = CellFactory.cellFactory
    let webService = WebService.webService
    let vcFactory = ViewControllerFactory.viewControllerFactory
    
    var communityId: Int?
//    var commuityPostList: CommuityPostList?
    var postList = [Post]()
    
    var currentPage = 0
    var size = 10
    var hasNext: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        tableViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        api()
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotification()
    }

}

// func
extension PostListViewController {
    
    func configure(id: Int) {
        communityId = id
    }
}


// notification
extension PostListViewController {
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name("Like"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToLikeList(_:)), name: NSNotification.Name("PostLikeList"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAlert(_:)), name: NSNotification.Name("deletePost"), object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    

}

// @objc
extension PostListViewController {
    
    @objc func reloadTableView(_ notification: Notification) {
        api()
    }
    
    @objc func moveToLikeList(_ notification: Notification) {
        guard let postId = notification.userInfo?["postId"] as? Int else {return}
        let vc = vcFactory.makeViewController(controllerType: .likeListType(.post), id: postId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteAlert(_ notification: Notification) {
        let alertController = UIAlertController(title: "게시글을 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        guard let postId = notification.userInfo?["postId"] as? Int else {return}
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else {return}
            self.deletePost(postId: postId)
        }
        alertController.addAction(cancelButton)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }
}


// api()
extension PostListViewController {
    
    
    func deletePost(postId: Int) {
        webService.deletePost(postId: postId) { [weak self] serverMessage in
            guard let self = self else {return}
            var alertController: UIAlertController!
            if serverMessage == nil {
                alertController = UIAlertController(title: "게시글이 삭제되었습니다.", message: nil, preferredStyle: .alert)
            } else {
                alertController = UIAlertController(title: serverMessage?.message, message: nil, preferredStyle: .alert)
            }
            let checkButton = UIAlertAction(title: "확인", style: .default)
            alertController.addAction(checkButton)
            self.present(alertController, animated: true)
            self.api()
            return
        }
        
        
//        webService.deletePost(postId: postId) { serverMessage in
//            let alertController = UIAlertController(title: serverMessage, message: nil, preferredStyle: .alert)
//            let checkButton = UIAlertAction(title: "확인", style: .default) { _ in
//                self.navigationController?.popViewController(animated: true)}
//            alertController.addAction(checkButton)
//            self.present(alertController, animated: true)
//            return
//        }
    }
    
    func api() {
        dataInit()
        fetch()
    }
    
    func dataInit() {
        hasNext = true
        currentPage = 0
        postList.removeAll()
    }
    
    func fetch() {
        guard let communityId = communityId else {return}
        if hasNext {
            webService.getCommunityPostList(communityId: communityId, page: currentPage, size: size) { [weak self] commuityPostList in
                guard let self = self else {return}
                self.navigationItem.title = commuityPostList.communityName

                if self.currentPage >= commuityPostList.pageInfo.nextPage {
                    return
                }
                self.currentPage = commuityPostList.pageInfo.nextPage
                self.hasNext = commuityPostList.pageInfo.hasNext
                self.postList += commuityPostList.posts
                self.postListTableView.reloadData()
            }
        }
    }
}

// tableView
extension PostListViewController {
    func tableViewSetting() {
        postListTableView.delegate = self
        postListTableView.dataSource = self
        postListTableView.prefetchDataSource = self
        postListTableView.rowHeight  = UITableView.automaticDimension
        postListTableView.register(UINib(nibName: CellType.post.toString(), bundle: nil), forCellReuseIdentifier: CellType.post.toString())
        postListTableView.register(UINib(nibName: CellType.postText.toString(), bundle: nil), forCellReuseIdentifier: CellType.postText.toString())
    }
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    // 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory.makeCell(cellType: .post, data: postList[indexPath.row], tableView: tableView, indexPath: indexPath)
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = vcFactory.makeViewController(controllerType: .postDetail, id: postList[indexPath.row].id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PostListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if hasNext && currentPage != 0 {
            indexPaths.forEach {
                if ($0.row + 1) / size + 1 == currentPage {
                    self.fetch()
                }
            }
        }

    }
}
