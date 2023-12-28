//
//  ProfileNavigationController.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/14.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
        navigationBar.backItem?.title = ""
        navigationItem.backBarButtonItem?.title = ""
        tabBarItem.title = "프로필"
        tabBarItem.image = UIImage(systemName: "person")
        tabBarItem.selectedImage = UIImage(systemName: "person.fill")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
