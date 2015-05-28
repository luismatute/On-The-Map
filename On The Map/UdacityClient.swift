//
//  UdacityClient.swift
//  On The Map
//
//  Created by Luis Matute on 5/26/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    // MARK: - Properties
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: - Class Properties
    override init() {
        super.init()
    }
    
    // MARK: - Convinience
    func getSession(username: String, passwd: String, callback: (success: Bool, error: String?) -> Void) {
        let jsonBody: String = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(passwd)\"}}"
        
        $.post("\(UdacityClient.URLs.BaseURL)\(UdacityClient.Methods.Session)").json(jsonBody).parseJSONWithCompletion(5){ (result, response, error) in
            println(result)
            if let error = error {
                callback(success: false, error: "error")
            } else {
                if let errorString = result.valueForKey(UdacityClient.JSONResponseKeys.Error) as? String {
                    callback(success: false, error: errorString)
                } else {
                    if let account = result.valueForKey(UdacityClient.JSONResponseKeys.Account) as? [String:AnyObject] {
                        if let userID: AnyObject = account[UdacityClient.JSONResponseKeys.UserID] {
                            self.userID = userID as? Int
                            callback(success: true, error: nil)
                        } else {
                            callback(success: false, error: "No UserID Found")
                        }
                    } else {
                        callback(success: false, error: "No Account found")
                    }
                }
            }
        }
    }
    
    func doLogout(callback: (success: Bool, error: String?) -> Void) {
        $.delete("\(UdacityClient.URLs.BaseURL)\(UdacityClient.Methods.Session)").cookies().parseJSONWithCompletion(5) { (result, response, error) in
            if let error = error {
                callback(success: false, error: "")
            } else {
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