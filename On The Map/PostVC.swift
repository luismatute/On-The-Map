//
//  PostVC.swift
//  On The Map
//
//  Created by Luis Matute on 5/28/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    var region: MKCoordinateRegion?
    var locationString: String?
    var dropPin: MKPointAnnotation?
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.region != nil {
            self.mapView.setRegion(self.region!, animated: true)
            self.mapView.addAnnotation(self.dropPin)
        } else {
            self.showError(title: "Error", msg: "No location found.")
        }
        self.loadingView.alpha = 0.0
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {}
    
    // MARK: - Actions
    @IBAction func cancelAction(sender: AnyObject) {
        let navVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavController") as! UINavigationController
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    @IBAction func submit(sender: AnyObject) {
        if let url = NSURL(string: self.linkTextField.text) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                // POST location
                let location_dict = [
                    "firstName": appDelegate.user!.firstName,
                    "lastName": appDelegate.user!.lastName,
                    "latitude": self.region!.center.latitude,
                    "longitude": self.region!.center.longitude,
                    "mapString": "\(self.locationString!)",
                    "mediaURL": "\(self.linkTextField.text)",
                    "uniqueKey": "\(appDelegate.user!.id)"
                ]
                var studentLocation = StudentLocation(dictionary: location_dict as! [String : AnyObject])
                
                self.showLoading(true)
                ParseClient.sharedInstance().postStudentLocation(studentLocation) { success, error in
                    if success {
                        let navVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavController") as! UINavigationController
                        self.presentViewController(navVC, animated: true, completion: nil)
                    } else {
                        self.showError(title: "Error Saving Data", msg: "The following error was returned from the Parse API: \(error!)")
                    }
                    self.showLoading(false)
                }
            } else {
                self.showError()
            }
        } else {
            self.showError()
        }
    }
    
    // MARK: - Methods
    func showError(title: String = "", msg: String = "") {
        var alert = UIAlertView()
        alert.title = (title == "") ? "Error" : title
        alert.message = (msg == "") ? "Invalid link, please check that you provided a valid link starting with \"http://\"." : msg
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
}