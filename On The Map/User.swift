//
//  User.swift
//  On The Map
//
//  Created by Luis Matute on 6/2/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation

struct User {
    var id = ""
    var sessionID = ""
    var firstName = ""
    var lastName = ""
    
    init(dict: [String: AnyObject]) {
        if let session = dict[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject] {
            if let account = dict[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] {
                id = account[UdacityClient.JSONResponseKeys.UserID] as! String
                sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as! String
            }
        }
    }
}