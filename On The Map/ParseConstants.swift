//
//  ParseConstants.swift
//  On The Map
//
//  Created by Luis Matute on 5/28/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

extension ParseClient {
    
    // MARK: - Constants
    struct Constants {
        
        static let APPID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let BaseURL = "https://api.parse.com/1/classes/"
    }
    
    // MARK: - Methods
    struct Methods {
        
        static let StudentLocation = "StudentLocation/"
        
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "object_id"
        
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let Limit = "limit"
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Student Location
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
        // MARK: Results
        static let Results = "results"
        
    }

    
}