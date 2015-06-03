//
//  UdacityClient.swift
//  On The Map
//
//  Created by Luis Matute on 5/26/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    // MARK: - Properties
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - Class Properties
    override init() {
        super.init()
    }
    
    // MARK: - Convinience
    func getSession(username: String, passwd: String, callback: (success: Bool, error: String?) -> Void) {
        let jsonBody: String = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(passwd)\"}}"
        
        $.post("\(UdacityClient.URLs.BaseURL)\(UdacityClient.Methods.Session)").json(jsonBody).parseJSONWithCompletion(5){ (result, response, error) in
            if let error = error {
                callback(success: false, error: error.localizedDescription)
            } else {
                if let errorString = result.valueForKey(UdacityClient.JSONResponseKeys.Error) as? String {
                    callback(success: false, error: errorString)
                } else {
                    var dict = result as! [String: AnyObject]
                    var user: User = User(dict: dict)
                    self.appDelegate.user = user
                    callback(success: true, error: nil)
                }
            }
        }
    }
    
    func getUserInfo(userID: String, callback: (success: Bool, error: String?) -> Void) {
        var urlString = UdacityClient.URLs.BaseURL + $.subtituteKeyInMethod(UdacityClient.Methods.User, key: UdacityClient.URLKeys.UserID, value: self.appDelegate.user!.id)!
        $.get(urlString).parseJSONWithCompletion(5) { (result, response, error) in
            if let error = error {
                callback(success: false, error: error.localizedDescription)
            } else {
                if let userResponse = result["user"] as? [String: AnyObject] {
                    var user = self.appDelegate.user
                    user?.firstName = userResponse["first_name"] as! String
                    user?.lastName = userResponse["last_name"] as! String
                    self.appDelegate.user = user!
                    callback(success: true, error: nil)
                } else {
                    callback(success: false, error: "No User found")
                }
            }
        }
    }
    
    func loginWithFB() {
        
    }
    
    func doLogout(callback: (success: Bool, error: String?) -> Void) {
        $.delete("\(UdacityClient.URLs.BaseURL)\(UdacityClient.Methods.Session)").cookies().parseJSONWithCompletion(5) { (result, response, error) in
            if let error = error {
                callback(success: false, error: error.localizedDescription)
            } else {
                self.appDelegate.user = nil
                callback(success: true, error: nil)
            }
        }
    }
    
    // MARK: - Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}