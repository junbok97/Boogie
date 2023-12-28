//
//  ProfileCommentCell.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/28.
//

import UIKit
import Kingfisher

class ProfileCommentCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    
    var profile: Profile!
    var comment: ProfileComment!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(profile: Profile?) {
        guard let profile = profile else {return}
        self.profile = profile
        self.comment = profile.comment
        userNameLabel.text = profile.user.name
        userTagLabel.text = profile.user.tagNum
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: comment.createdAt)
        contentLabel.text = comment.content
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        let imageURL = URL(string: profile.user.profileImageUrl ?? "")
        userProfileImageView.kf.setImage(with: imageURL,placeholder: UIImage(systemName: "person.fill"))
        userProfileImageView.contentMode = .scaleAspectFill
    }
}
