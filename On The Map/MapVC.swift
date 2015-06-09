//
//  MapVC.swift
//  On The Map
//
//  Created by Luis Matute on 5/26/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    var locations: [StudentLocation] = [StudentLocation]()
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.init_map()
        self.setup_nav()
    }
    
    // MARK: - Delegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    
    // MARK: - Actions
    func do_logout() {
        self.showLoading(true)
        UdacityClient.sharedInstance().doLogout() { success, error in
            self.showLoading(false)
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as! LoginVC
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    func post_location() {
        let wruVC = self.storyboard?.instantiateViewControllerWithIdentifier("WhereAreYouVC") as! WhereAreYouVC
        self.presentViewController(wruVC, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func init_map() {
        self.showLoading(true)
        ParseClient.sharedInstance().getStudentLocations(false) { result, errorString in
            if let locations = result {
                self.locations = locations
                var annotations = [MKPointAnnotation]()
                
                for location in self.locations {
                    let lat = CLLocationDegrees(location.latitude as Double)
                    let lon = CLLocationDegrees(location.longitude as Double)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    
                    let first = location.firstName as String
                    let last = location.lastName as String
                    let mediaURL = location.mediaURL as String
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
            } else {
                self.showError(title: "Error Downloading Locations", msg: errorString!)
            }
            self.showLoading(false)
        }
    }
    func setup_nav() {
        var logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "do_logout")
        var pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "post_location")
        var reloadButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "init_map")
        
        logoutButton.tintColor = UIColor.whiteColor()
        pinButton.tintColor = UIColor.whiteColor()
        reloadButton.tintColor = UIColor.whiteColor()
        
        self.parentViewController!.navigationItem.leftBarButtonItem = logoutButton
        self.parentViewController!.navigationItem.rightBarButtonItems = [reloadButton, pinButton]
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
        alert.message = (msg == "") ? "Invalid Location" : msg
        alert.addButtonWithTitle("OK")
        alert.show()
    }

}