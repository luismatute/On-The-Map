//
//  WhereAreYouVC.swift
//  On The Map
//
//  Created by Luis Matute on 6/1/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class WhereAreYouVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    var region = MKCoordinateRegion()
    var dropPin = MKPointAnnotation()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.alpha = 0.0
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.tapRecognizer?.numberOfTapsRequired = 1
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postSegue" {
            if var postVC = segue.destinationViewController as? PostVC {
                postVC.region = self.region
                postVC.dropPin = self.dropPin
                postVC.locationString = locationTextField.text
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func findOnMap(sender: AnyObject) {
        if locationTextField.text == "" {
            self.showError(title: "Error", msg: "Please make sure to fill in all fields.")
            return
        }
        
        let geoCoder = CLGeocoder()
        self.showLoading(true)
        geoCoder.geocodeAddressString(locationTextField.text){ info, error in
            if let e = error {
                self.showError(title: "", msg: error.localizedDescription)
            } else {
                if let places = info as? [CLPlacemark]{
                    let coordinate = places[0].location.coordinate
                    let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
                    self.region = MKCoordinateRegion(center: coordinate, span: span)
                    self.dropPin.coordinate = coordinate
                    self.performSegueWithIdentifier("postSegue", sender: nil)
                }
            }
            self.showLoading(false)
        }
    }
    
    // MARK: - Methods
    func showError(title: String = "", msg: String = "") {
        var alert = UIAlertView()
        alert.title = (title == "") ? "Bad Location" : title
        alert.message = (msg == "") ? "Could not find location specified." : msg
        alert.addButtonWithTitle("OK")
        alert.show()
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
    func keyboardWillShow(notification:NSNotification){
        self.view.frame.origin = CGPointMake(0.0, -getKeyboardHeight(notification))
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.view.frame.origin = CGPointMake(0.0, 0.0)
    }
    
    func getKeyboardHeight(notification:NSNotification)->CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object:nil)
    }

}