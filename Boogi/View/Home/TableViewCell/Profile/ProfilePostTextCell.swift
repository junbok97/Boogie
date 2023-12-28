//
//  ProfilePostImageCell.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/28.
//

import UIKit
import Kingfisher
//import ImageSlideshow

class ProfilePostTextCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var communityButton: UIButton!
//    @IBOutlet weak var postImageSlideShow: ImageSlideshow!
    
    var profile: Profile!
    var post: ProfilePost!
//    var imageList = [KingfisherSource]()
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(profile: Profile?) {
        guard let profile = profile else {return}
        self.post = profile.post
//        imageList.removeAll()
        userNameLabel.text = profile.user.name
        userTagLabel.text = profile.user.tagNum
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: post.createdAt)
        contentLabel.text = post.content
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        var hash = ""
        post.hashtags?.forEach{
            hash = "#\($0) " + hash
        }
        hashTagLabel.text = hash
        
        communityButton.setTitle(post.community.name, for: .normal)
        
        let imageURL = URL(string: profile.user.profileImageUrl ?? "")
        userProfileImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "person.fill"))
        userProfileImageView.contentMode = .scaleAspectFill
//
//
//        if let postMedias = post.postMedias {
//            postMedias.forEach{ postMedia in
//                imageList.append(KingfisherSource(urlString: postMedia.url)!)
//            }
//            postImageSlideShow.setImageInputs(imageList)
//            postImageSlideShow.snp.makeConstraints {
//                $0.height.equalTo(400)
//            }
//            postImageSlideShow.contentScaleMode = .scaleAspectFit
//        } else {
//            postImageSlideShow.snp.makeConstraints {
//                $0.height.equalTo(0)
//            }
//        }

    }
    
    @IBAction func communityButtonTapped(_ sender: Any) {
        
        NotificationCenter.default.post(
            name: NSNotification.Name("ProfileMoveCommunityHome"),
            object: nil,
            userInfo: ["communityId" : post.community.id])
    }
    
}
