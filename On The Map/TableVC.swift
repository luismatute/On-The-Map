//
//  TableVC.swift
//  On The Map
//
//  Created by Luis Matute on 5/28/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import UIKit

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    var locations: [StudentLocation] = [StudentLocation]()
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    // MARK: - Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseID = "locationViewCell"
        let location = self.locations[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseID) as! UITableViewCell
        
        cell.textLabel!.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        cell.textLabel?.textColor = $.uicolorFromHex(0x939CBA)
        cell.imageView!.image = UIImage(named: "Pin")
        cell.tintColor = UIColor.whiteColor()
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: self.locations[indexPath.row].mediaURL)!)
    }
    
    // MARK: - Actions
    
    // MARK: - Methods
    func getData() {
        ParseClient.sharedInstance().getStudentLocations(true) { result, error in
            if let locations = result {
                self.locations = locations
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                println(error)
            }
        }
    }

}
