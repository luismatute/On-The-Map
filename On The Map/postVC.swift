//
//  postVC.swift
//  On The Map
//
//  Created by Luis Matute on 5/28/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation
import UIKit

class postVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var locationTextField: UITextField!
    
    // MARK: - Properties
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    // MARK: - Actions
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func findOnMap(sender: AnyObject) {
    }
    
    
    // MARK: - Methods
}