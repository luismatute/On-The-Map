//
//  NavBarVC.swift
//  On The Map
//
//  Created by Luis Matute on 6/1/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation
import UIKit

class NavBarVC:UINavigationController {
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        self.setup_btns()
    }
    
    // MARK: - Methods
    func setup_btns() {
        var logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "do_logout")
        var pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "post_location")
        var reloadButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "getData")
        
//        self.navigationItem.leftBarButtonItem = logoutButton
//        self.navigationItem.rightBarButtonItems = [reloadButton, pinButton]
    }
    
    func do_logout() {
        UdacityClient.sharedInstance().doLogout() { success, error in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}