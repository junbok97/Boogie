//
//  PostDetailViewController.swift
//  boogi_comunity
//
//  Created by 이준복 on 2022/03/31.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    let vcFactory = ViewControllerFactory.viewControllerFactory
    let webService = WebService.webService
    let cellFactory = CellFactory.cellFactory
    
    var postId: Int?
    var post: Post?
    var commentId : Int?
    var commentList = [Comment]()
    var currentPage = 0
    let size = 10
    var hasNext: Bool = true
    
    var calledWillShow = false
    var calledWillHide = false
    var calledFirst = false
    var keyboardYValue = CGFloat(0)
    
    var commentViewConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var postDetailTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
        commentTextField.inputAccessoryView = nil
        tableViewSetting()
        navigationItem.backButtonTitle = ""
        
        commentViewConstraint = commentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10)
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentViewConstraint?.isActive = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

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
    
    @IBAction func commentSend(_ sender: UIButton) {
        createComment()
//        commentTextField.resignFirstResponder()
//        calledWillHide = false
//        commentViewConstraint?.isActive = true
    }
}


// func
extension PostDetailViewController {
    
    func configure(id: Int) {
        postId = id
        api()
    }
    
    func dataInit() {
        hasNext = true
        currentPage = 0
        commentList.removeAll()
        fetch()
    }
    
}

//notification
extension PostDetailViewController {
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(NameType.like.toString()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToLikeList(_:)), name: NSNotification.Name(NameType.postLikeList.toString()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToLikeList(_:)), name: NSNotification.Name(NameType.commentLikeList.toString()), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(postDeleteNoti(_:)), name: NSNotification.Name(NameType.postDelete.toString()), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(commentDeleteNoti(_:)), name: NSNotification.Name(NameType.commentDelete.toString()), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveToProfile(_:)), name: NSNotification.Name(NameType.moveToProfile.toString()), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reComment(_:)), name: NSNotification.Name(NameType.reComment.toString()), object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
  
}

//@objc
extension PostDetailViewController {
    
    @objc func reComment(_ notification: Notification) {
        guard let commentId = notification.userInfo?["commentId"] as? Int else {return}
        self.commentId = commentId
        let alertController = UIAlertController(title: "대댓글을 작성하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.commentTextField.becomeFirstResponder()
        }
        alertController.addAction(cancelButton)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }

    @objc func moveToProfile(_ notification: Notification) {
        guard let userId = notification.userInfo?["userId"] as? Int else {return}
        let vc = vcFactory.makeViewController(controllerType: .profile, id: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func commentDeleteNoti(_ notification: Notification) {
        guard let commentId = notification.userInfo?["commentId"] as? Int else {return}
        self.commentId = commentId
        let alertController = UIAlertController(title: "댓글을 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: deleteComment)
        alertController.addAction(cancelButton)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }
    
    @objc func postDeleteNoti(_ notification: Notification) {
        let alertController = UIAlertController(title: "게시글을 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: deletePost)
        alertController.addAction(cancelButton)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }
    
    @objc func reloadTableView(_ notification: Notification) {
      api()
    }

    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        commentTextField.resignFirstResponder()
    }
    
    @objc func moveToLikeList(_ notification: Notification) {
        guard let listType = notification.userInfo?["listType"] as? ListType else {return}
        var id: Int?
        switch listType {
        case .post:
            guard let postId = notification.userInfo?["postId"] as? Int else {return}
            id = postId
        case .comment:
            guard let commentId = notification.userInfo?["commentId"] as? Int else {return}
            id = commentId
        }
        let vc = vcFactory.makeViewController(controllerType: .likeListType(listType), id: id)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func keyboardWillShow(_ noti: NSNotification){
        
        if calledWillShow {
            return
        }
        
        if calledFirst {
            calledWillShow = true
            calledWillHide = false
            commentViewConstraint?.constant -= keyboardYValue
            return
        } else {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                commentViewConstraint?.constant -= (keyboardHeight-(self.tabBarController?.tabBar.frame.size.height)!)
                keyboardYValue = (keyboardHeight-(self.tabBarController?.tabBar.frame.size.height)!)
                calledWillShow = true
                calledWillHide = false
                calledFirst = true
            }
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification){
        if calledWillHide {
            return
        }
        
        if calledFirst {
            calledWillShow = false
            calledWillHide = true
            commentViewConstraint?.constant += keyboardYValue
            return
        } else {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                commentViewConstraint?.constant += (keyboardHeight-(self.tabBarController?.tabBar.frame.size.height)!)
                calledWillShow = false
                calledWillHide = true
            }
        }
    }

}

// api
extension PostDetailViewController {
        
    func createComment(){
        webService.createComment(comment: CreatedComment(postId: postId!, content: commentTextField.text!, parentCommentId: commentId, mentionedUserIds: [Int]())){ [weak self] in
            guard let self = self else {return}
            self.commentTextField.text = ""
            let alertController = UIAlertController(title: "댓글이 작성되었습니다.", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
                guard let self = self else {return}
                self.api()
            })
            alertController.addAction(okButton)
            self.present(alertController, animated: true)
            self.commentId = nil
        }
    }
    
    func deleteComment(alert: UIAlertAction){
        guard let commentId = commentId else {return}
        webService.deleteComment(commentId: commentId){ [weak self] serverMessage in
            guard let self = self else {return}
            var alertController: UIAlertController!
            if serverMessage == nil {
                alertController = UIAlertController(title: "댓글이 삭제되었습니다.", message: nil, preferredStyle: .alert)
            } else {
                alertController = UIAlertController(title: serverMessage?.message, message: nil, preferredStyle: .alert)
            }
            let checkButton = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
                guard let self = self else {return}
                self.api()
            })
            alertController.addAction(checkButton)
            self.present(alertController, animated: true)
            
            return
        }
    }
    
    
    func deletePost(alert: UIAlertAction) {
        guard let postId = postId else {return}
        var checkButton: UIAlertAction!
        webService.deletePost(postId: postId) { [weak self] serverMessage in
            guard let self = self else {return}
            var alertController: UIAlertController!
            if serverMessage == nil {
                alertController = UIAlertController(title: "게시글이 삭제되었습니다.", message: nil, preferredStyle: .alert)
            } else {
                alertController = UIAlertController(title: serverMessage?.message, message: nil, preferredStyle: .alert)
            }
            switch serverMessage?.statusCode {
            case 200,403:
                checkButton = UIAlertAction(title: "확인", style: .default)
            default :
                checkButton = UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)}
            }
            alertController.addAction(checkButton)
            self.present(alertController, animated: true)
            return
        }
    }

    func api() {
        guard let postId = postId else {return}
        webService.getPostDetail2(postId: postId) { [weak self] post in
            guard let self = self else {return}
            self.post = post
            self.navigationItem.title = post?.community?.name
            self.postDetailTableView.reloadData()
        }
        dataInit()
    }

    func fetch() {
        guard let postId = postId else {return}
        if hasNext {
            webService.getComments(postId: postId, page: currentPage, size: size) { [weak self] comments in
                guard let self = self else {return}
                if self.currentPage >= comments.pageInfo.nextPage {
                    return
                }
                self.hasNext = comments.pageInfo.hasNext
                self.currentPage = comments.pageInfo.nextPage
                self.commentList += comments.comments
                self.postDetailTableView.reloadData()
            }
        }
    }
}

// talbeViewSetting
extension PostDetailViewController {
    func tableViewSetting() {
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
        postDetailTableView.prefetchDataSource = self
        postDetailTableView.rowHeight = UITableView.automaticDimension
        postDetailTableView.register(UINib(nibName: CellType.post.toString(), bundle: nil), forCellReuseIdentifier: CellType.post.toString())
        postDetailTableView.register(UINib(nibName: CellType.postText.toString(), bundle: nil), forCellReuseIdentifier: CellType.postText.toString())
        postDetailTableView.register(UINib(nibName: CellType.comment.toString(), bundle: nil), forCellReuseIdentifier: CellType.comment.toString())
        postDetailTableView.register(UINib(nibName: CellType.reComment.toString(), bundle: nil), forCellReuseIdentifier: CellType.reComment.toString())
        postDetailTableView.register(UINib(nibName: "CommentHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CommentHeader")

    }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return commentList.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return commentList[section - 1].child?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
              case 0:
                  return "\(post?.likeCount ?? 0)명이 좋아합니다."
              default:
                  return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default :
            
            let comment = commentList[section - 1]
            if comment.user != nil {
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentHeader") as! CommentHeader
                headerView.configure(with: comment)
                return headerView
            } else {
                return HeaderViewFactory.headerViewFactory.makeHeaderView(headertype: .comment, title: .deleteCommet)
            }
           
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return tableView.rowHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
             return cellFactory.makeCell(cellType: .post, data: post, tableView: tableView, indexPath: indexPath)
         default:
            return cellFactory.makeCell(cellType: .reComment, data: commentList[indexPath.section - 1].child?[indexPath.row], tableView: tableView, indexPath: indexPath)
         }
    }
    
}

extension PostDetailViewController: UITableViewDataSourcePrefetching {
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

extension PostDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
