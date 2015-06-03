//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Luis Matute on 5/26/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

extension UdacityClient {

    // MARK: - Constants
    struct Constants {
        static let fbToken: String = ""
    }
    
    // MARK: - URLs
    struct URLs {

        static let BaseURL: String = "https://www.udacity.com/api/"
        static let SignUpURL: String = "https://www.udacity.com/account/auth#!/signin"
    }
    
    // MARK: - Methods
    struct Methods {
        
        static let User = "users/{user_id}"
        static let Session = "session"
        
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "user_id"
 
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
    
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Account
        static let Account = "account"
        static let UserID = "key"
        
        // MARK: Session
        static let Session = "session"
        static let SessionID = "id"
        
        // MARK: Error
        static let Error = "error"
        static let StatusCode = "status"
                
    }

}