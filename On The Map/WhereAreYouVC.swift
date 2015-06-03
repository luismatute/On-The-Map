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
    
    // MARK: - Properties
    var region = MKCoordinateRegion()
    var dropPin = MKPointAnnotation()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let geoCoder = CLGeocoder()
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

}