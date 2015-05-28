//
//  LoginVC.swift
//  On The Map
//
//  Created by Luis Matute on 5/26/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class LoginVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Properties
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup_ui()
    }
    
    // MARK: - Actions
    @IBAction func loginWithUdacity(sender: AnyObject) {
        let jsonBody: String = "{\"udacity\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(emailTextField.text)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(passwordTextField.text)\"}}"
        
        UdacityClient.sharedInstance().getSession(self.emailTextField.text, passwd: self.passwordTextField.text) { (success, error) in
            if success {
                 let navVC = self.storyboard?.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
                 self.presentViewController(navVC, animated: true, completion: nil)
                println("Awesome!")
            } else {
                println(error)
            }
        }
    }
    
    // MARK: - Methods
    func setup_ui() {
        // Gradient for View
        let view: UIView = self.view
        // create gradient layer
        let gradient : CAGradientLayer = CAGradientLayer()
        // create color array
        let arrayColors: [AnyObject] = [
            UIColor(red: 253/255.0, green: 152/255.0, blue: 42/255.0, alpha: 1.0).CGColor,
            UIColor(red: 252/255.0, green: 111/255.0, blue: 34/255.0, alpha: 1.0).CGColor
        ]
        // set gradient frame bounds to match view bounds
        gradient.frame = view.bounds
        // set gradient's color array
        gradient.colors = arrayColors
        // replace base layer with gradient layer
        view.layer.insertSublayer(gradient, atIndex: 1)
        
        // Text Fields
        self.emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    }
}