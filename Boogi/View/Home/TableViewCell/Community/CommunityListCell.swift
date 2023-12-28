//
//  CommunityListCell.swift
//  Home
//
//  Created by 이준복 on 2022/05/02.
//

import UIKit
import Kingfisher

class CommunityListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var hasTagLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
        
    var community: JoinCommunity.Community!
    var communityId: Int!
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func communityhomeButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(
            name: NSNotification.Name("HomeMoveCommunityHome"),
            object: nil,
            userInfo: ["communityId" : communityId!])
    }
}

extension CommunityListCell {
    
    func configure(community: JoinCommunity.Community?) {
        guard let community = community else {return}
        self.community = community
        communityId = community.id
        post = community.post
        selectionStyle = .none
        settingCell()
    }
    
    func settingCell() {
        titleLabel.text = community.name
        contentsLabel.text = post?.content ?? "작성된 게시글이 없습니다."
        likeButton.setTitle(String(post?.likeCount ?? 0), for: .normal)
        commentButton.setTitle(String(post?.commentCount ?? 0), for: .normal)
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: post?.createdAt)
        
        var hash = ""
        post?.hashtags?.forEach{
            hash = "#\($0) " + hash
        }
        hasTagLabel.text = hash
        
        if post == nil {
            createdAtLabel.isHidden = true
            likeButton.isHidden = true
            commentButton.isHidden = true
        } else {
            createdAtLabel.isHidden = false
            likeButton.isHidden = false
            commentButton.isHidden = false
        }
    }
    
    
}
