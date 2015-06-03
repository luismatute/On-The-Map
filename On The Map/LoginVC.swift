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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup_ui()
    }
    
    // MARK: - Actions
    @IBAction func singupAction(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: UdacityClient.URLs.SignUpURL)!)
    }
    @IBAction func loginWithUdacity(sender: AnyObject) {
        // One of the fields is empty
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.showError(title: "Error", msg: "Please make sure to fill in all fields.")
            return
        }
        let jsonBody: String = "{\"udacity\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(emailTextField.text)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(passwordTextField.text)\"}}"
        
        self.showLoading(true)
        UdacityClient.sharedInstance().getSession(self.emailTextField.text, passwd: self.passwordTextField.text) { (success, error) in
            if success {
                UdacityClient.sharedInstance().getUserInfo(self.appDelegate.user!.id) { success, errorString in
                    if success {
                        let navVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavController") as! UINavigationController
                        self.presentViewController(navVC, animated: true, completion: nil)
                    } else {
                        self.showError(title: "Error", msg: errorString!)
                        self.showLoading(false)
                    }
                }
            } else {
                self.showError(title: "Error", msg: error!)
                self.showLoading(false)
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
        
        self.loadingView.alpha = 0.0
    }
    func showLoading(show: Bool) {
        if show {
            UIView.animateWithDuration(0.4, animations: {
                self.loadingView.alpha = 1.0
                self.spinner.startAnimating()
            })
        } else {
            UIView.animateWithDuration(0.4, animations: {
                self.loadingView.alpha = 0.0
                self.spinner.stopAnimating()
            })
        }
    }
    func showError(title: String = "", msg: String = "") {
        var alert = UIAlertView()
        alert.title = (title == "") ? "Error" : title
        alert.message = (msg == "") ? "There seems to be an error" : msg
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
}