//
//  CommunityNoticeCell.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/22.
//

import UIKit

class CommunityNoticeCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userProfileName: UILabel!
    @IBOutlet weak var userProfileTagNum: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(notice: Notice?) {
        selectionStyle = .none
        titleLabel.text = notice?.title
        contentLabel.text = notice?.content
        createdAtLabel.text = notice?.createdAt
        userProfileName.text = notice?.user?.name
        userProfileTagNum.text = notice?.user?.tagNum
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: notice?.createdAt)
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        if let profileImageUrl = notice?.user?.profileImageUrl {
            let imageURL = URL(string: profileImageUrl)
            userProfileImageView.kf.setImage(with: imageURL)
            userProfileImageView.contentMode = .scaleAspectFill
        }
    }

    
}
