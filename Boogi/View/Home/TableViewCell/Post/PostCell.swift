//
//  PostImageCell.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/25.
//

import UIKit
import Kingfisher
import SnapKit
import ImageSlideshow

class PostCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var postImageSlideShow: ImageSlideshow!
    
    @IBOutlet weak var plusButton: UIButton!
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    let webService = WebService.webService
    
    var likeId: Int? {
        didSet {
            self.likeButtonImageSetting()
        }
    }
    
    var userId: Int!
    var postId: Int!
    
    var imageList = [KingfisherSource]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with post: Post?) {
        selectionStyle = .none
        plusButtonSetting()
        guard let post = post else {return}
        imageList.removeAll()
        
        userId = post.user?.id
        postId = post.id
        userNameLabel.text = post.user?.name
        userTagLabel.text = post.user?.tagNum
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: post.createdAt) 
        contentsLabel.text = post.content
        likeButton.setTitle(String(post.likeCount ?? 0), for: .normal)
        commentButton.setTitle(String(post.commentCount ?? 0), for: .normal)
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        var hash = ""
        post.hashtags?.forEach{
            hash = "#\($0) " + hash
        }
        hashTagLabel.text = hash
        
        likeId = post.likeId
        likeButtonImageSetting()
        
        let imageURL = URL(string: post.user?.profileImageUrl ?? "")
        userProfileImageView.kf.setImage(with: imageURL,placeholder: UIImage(systemName: "person.fill"))
        userProfileImageView.contentMode = .scaleAspectFill
        
        if let postMedias = post.postMedias {
            postMedias.forEach{ postMedia in
                imageList.append(KingfisherSource(urlString: postMedia.url)!)
            }
            postImageSlideShow.setImageInputs(imageList)
            postImageSlideShow.snp.makeConstraints {
                $0.height.equalTo(400)
            }
            postImageSlideShow.contentScaleMode = .scaleAspectFit
        } else {
            postImageSlideShow.snp.makeConstraints {
                $0.height.equalTo(0)
            }
        }

    }
    
    let optionsClosure = { (action: UIAction) in
      print(action.title)
    }
    
    func plusButtonSetting(){
        plusButton.menu = UIMenu(children: [
//            UIAction(title: "수정", image: UIImage(systemName: "pencil"), handler: optionsClosure),
            UIAction(title: "프로필 이동", image: UIImage(systemName: "person.fill"),handler: moveToProfile),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: deletePost),
            UIAction(title: "좋아요 목록", image: UIImage(systemName: "list.dash"),handler: showPostLikeList)
          ])
    }
    
    func moveToProfile(action: UIAction) {
        NotificationCenter.default.post(name: NSNotification.Name(NameType.moveToProfile.toString()),object: nil, userInfo: ["userId" : userId!])
    }
    
    
    func showPostLikeList(action: UIAction) {
        NotificationCenter.default.post(name: NSNotification.Name(NameType.postLikeList.toString()),object: nil, userInfo: ["postId" : postId!,"listType" : ListType.post])
    }
    
    func deletePost(action: UIAction) {
        NotificationCenter.default.post(name: NSNotification.Name(NameType.postDelete.toString()),object: nil, userInfo: ["postId" : postId!])
    }
    
    func likeButtonImageSetting() {
        if likeId != nil {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        if likeId != nil {
            webService.deleteLike(id: likeId!) { [weak self] in
                guard let self = self else {return}
                self.likeId = nil
                NotificationCenter.default.post(name: NSNotification.Name(NameType.like.toString()),object: nil)
            }
        } else {
            webService.postLike(id: postId) { [weak self] like in
                guard let self = self else {return}
                self.likeId = like.id
                NotificationCenter.default.post(name: NSNotification.Name(NameType.like.toString()),object: nil)
            }
        }
    }
    
  
    

}
