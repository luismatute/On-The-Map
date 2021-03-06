//
//  TabBarVC.swift
//  On The Map
//
//  Created by Luis Matute on 6/1/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation
import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        UITabBar.appearance().tintColor = UIColor.whiteColor()

        var logoutBtn = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "do_logout")
        self.navigationController?.navigationItem.rightBarButtonItem = logoutBtn
    }
    
}