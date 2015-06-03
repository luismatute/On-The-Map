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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!

    // MARK: - Properties
    var locations: [StudentLocation] = [StudentLocation]()
    
    // MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup_nav()
        self.loadingView.alpha = 0.0
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
        cell.detailTextLabel!.text = location.mediaURL
        cell.detailTextLabel!.textColor = $.uicolorFromHex(0x939CBA)
        cell.textLabel!.textColor = UIColor.whiteColor()
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
    func getData() {
        self.showLoading(true)
        ParseClient.sharedInstance().getStudentLocations(true) { result, error in
            if let locations = result {
                self.locations = locations
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                println(error)
            }
            self.showLoading(false)
        }
    }
    func setup_nav() {
        var logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "do_logout")
        var pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "post_location")
        var reloadButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "getData")
        
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

}
