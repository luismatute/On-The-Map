//
//  StudentLocation.swift
//  On The Map
//
//  Created by Luis Matute on 5/28/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//


struct StudentLocation {
    
    // MARK: - Properties
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    // MARK: - Contructor
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as! String
    }
    
    // MARK: - Helpers
    static func studentLocationFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
}