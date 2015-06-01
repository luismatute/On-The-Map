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
    var locations: [StudentLocation] = [StudentLocation]()
    
    // MARK: - Properties
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.init_map()
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
    
    // MARK: - Methods
    func init_map() {

        ParseClient.sharedInstance().getStudentLocations(false) { result, error in
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
                println(error)
            }
        }
        
        /*
        // Posting my location
        var location_dict = [
            "firstName": "Luis",
            "lastName": "Matute",
            "latitude": 15.5611942,
            "longitude": -88.0228433,
            "mapString": "San Pedro Sula, Cortes, Honduras.",
            "mediaURL": "https://www.linkedin.com/in/matuteluis",
            "uniqueKey": "\(UdacityClient.sharedInstance().userID)"
        ]
        var studentLocation = StudentLocation(dictionary: location_dict as! [String : AnyObject])
        
        ParseClient.sharedInstance().postStudentLocation(studentLocation) { result, error in
        
        }
        */
    }

}