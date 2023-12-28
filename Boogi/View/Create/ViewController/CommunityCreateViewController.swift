//
//  CommunityCreateViewController.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/16.
//

import UIKit
import SwiftUI

class CommunityCreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBSegueAction func addSwiftUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CommunityCreateView())
    }
    
}
