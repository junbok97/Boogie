//
//  TabBarViewController.swift
//  Test
//
//  Created by 이준복 on 2022/05/05.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegate = self
        let storyBoard:UIStoryboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        viewControllers?.append(ProfileNavigationController(rootViewController: vc))
    }
    
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print(tabBarItem.tag)
//    }
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//
//        let newController = viewControllers![2] as! CreateViewController
//
//        if viewController == newController {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "test") as? testViewController
//
//
//            vc?.view.backgroundColor = .darkGray.withAlphaComponent(0.3)
//            vc?.modalPresentationStyle = .overFullScreen
//
//            viewController.present(vc!, animated: true, completion: nil)
//
//            return false
//        }
//
//        return true
//    }
 }
