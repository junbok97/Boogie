//
//  AlarmViewController.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/14.
//

import UIKit
import SwiftUI

class AlarmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "알람"
    }
    
    
    @IBSegueAction func addSwiftUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: AlarmMessageView())
    }
    
}
