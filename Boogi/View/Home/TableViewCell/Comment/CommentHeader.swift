//
//  CommentHeader.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/31.
//

import UIKit

class CommentHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var reCommentButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    let webService = WebService.webService
    
    var likeId: Int? {
        didSet {
            self.likeButtonImageSetting()
        }
    }
    var commentId: Int!
    var userId: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    @IBAction func reCommentTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(NameType.reComment.toString()),object: nil, userInfo: ["commentId" :commentId!])
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if likeId != nil {
            webService.deleteLike(id: likeId!) { [weak self] in
                guard let self = self else {return}
                self.likeId = nil
                NotificationCenter.default.post(name: NSNotification.Name("Like"),object: nil)
            }
        } else {
            webService.commentLike(id: commentId!) { [weak self] like in
                guard let self = self else {return}
                self.likeId = like.id
                NotificationCenter.default.post(name: NSNotification.Name("Like"),object: nil)
            }
        }
    }

    
    @IBAction func likeCountButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(NameType.commentLikeList.toString()),object: nil, userInfo: ["commentId" :commentId!, "listType" : ListType.comment])
    }
}


// func
extension CommentHeader {
    
    func configure(with comment: Comment?) {
        guard let comment = comment else {return}
        commentId = comment.id
        userId = comment.user?.id
        userNameLabel.text = comment.user?.name
        userTagLabel.text = comment.user?.tagNum
        contentsLabel.text = comment.content
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: comment.createdAt)
        likeCountButton.setTitle("좋아요 \(comment.likeCount)개", for: .normal)
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        let imageURL = URL(string: comment.user?.profileImageUrl ?? "")
        userProfileImageView.kf.setImage(with: imageURL,placeholder: UIImage(systemName: "person.fill"))
        userProfileImageView.contentMode = .scaleAspectFill
        likeId = comment.likeId
        likeButtonImageSetting()
        plusButtonSetting()
        
    }
    
    func likeButtonImageSetting() {
        if likeId != nil {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func plusButtonSetting(){
        plusButton.menu = UIMenu(children: [
            UIAction(title: "프로필 이동", image: UIImage(systemName: "person.fill"),handler: moveToProfile),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: deleteComment)
          ])
    }
    
    func moveToProfile(action: UIAction) {
        NotificationCenter.default.post(name: NSNotification.Name(NameType.moveToProfile.toString()),object: nil, userInfo: ["userId" : userId!])
    }
    
    func deleteComment(action: UIAction) {
        NotificationCenter.default.post(name: NSNotification.Name(NameType.commentDelete.toString()),object: nil, userInfo: ["commentId" : commentId!])
    }
    

}
