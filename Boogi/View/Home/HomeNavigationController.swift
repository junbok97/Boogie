//
//  HomeNavigationController.swift
//  Test
//
//  Created by 이준복 on 2022/05/05.
//

import UIKit


class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
        navigationItem.backBarButtonItem?.title = ""
        navigationItem.backBarButtonItem?.title = ""
        navigationItem.backButtonTitle = ""
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}
