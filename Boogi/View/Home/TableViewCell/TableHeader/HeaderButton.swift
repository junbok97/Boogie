//
//  HeaderButton.swift
//  Test
//
//  Created by 이준복 on 2022/05/04.
//

import UIKit

class HeaderButton: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var navigationController: UINavigationController?
    var controllerType: ControllerType?
    var id: Int?

    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: TitleType, navigationController: UINavigationController?, controllerType: ControllerType, id: Int?) {
        self.titleLabel.text = title.toString()
        self.navigationController = navigationController
        self.controllerType = controllerType
        self.id = id
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        let vc = ViewControllerFactory().makeViewController(controllerType: self.controllerType!, id: self.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
