//
//  LikeListCell.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/27.
//

import UIKit
import Kingfisher

class LikeListCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!

    var user: LikeList.User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(user: LikeList.User) {
        selectionStyle = .none
        self.user = user
        userNameLabel.text = user.name
        userTagLabel.text = user.tagNum
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        let imageURL = URL(string: user.profileImageUrl ?? "")
        userProfileImageView.kf.setImage(with: imageURL,placeholder: UIImage(systemName: "person.fill"))
        userProfileImageView.contentMode = .scaleAspectFill
    }
}
