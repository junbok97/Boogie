//
//  ProfileCell.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/30.
//

import UIKit
import Kingfisher

class ProfileCell: UITableViewCell {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var userIntroduce: UILabel!
    @IBOutlet weak var userDepartmentLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(user: User) {
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        userNameLabel.text = user.name
        userTagLabel.text = user.tagNum
        userIntroduce.text = user.introduce
        userDepartmentLabel.text = user.department
        userProfileImageView.contentMode = .scaleAspectFill
        let imageURL = URL(string: user.profileImageUrl ?? "")
        userProfileImageView.kf.setImage(with: imageURL,placeholder: UIImage(systemName: "person.fill"))
    }
}
