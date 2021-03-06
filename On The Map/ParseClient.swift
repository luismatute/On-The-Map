//
//  ParseClient.swift
//  On The Map
//
//  Created by Luis Matute on 5/28/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    // MARK: - Properties
    let auth = [
        Constants.APPID: "X-Parse-Application-Id",
        Constants.APIKey: "X-Parse-REST-API-Key"
    ]
    var locations = [StudentLocation]()
    
    // MARK: - Class Properties
    override init() {
        super.init()
    }
    
    // MARK: - Convinience
    func getStudentLocations(forceDownload: Bool, callback: (result: [StudentLocation]?, errorString: String?) -> Void) {
        let parameters = [ParameterKeys.Limit: 100]
        let mutableParameters = $.escapedParameters(parameters)
        let urlString = "\(ParseClient.Constants.BaseURL)\(ParseClient.Methods.StudentLocation)" + mutableParameters
        var le_results = [StudentLocation]()
        
        // Check if we have already loaded the locations
        // If there is nothing, fetch them
        if self.locations.count == 0 || forceDownload == true {
            $.get(urlString).genericValues(auth).parseJSONWithCompletion(0) { (result, response, error) in
                if let error = error {
                    callback(result: nil, errorString: error.localizedDescription)
                } else {
                    if let results = result.valueForKey(JSONResponseKeys.Results) as? [[String : AnyObject]] {
                        var locations = StudentLocation.studentLocationFromResults(results)
                        callback(result: locations, errorString: nil)
                    } else {
                        callback(result: nil, errorString: "No Results Found")
                    }
                }
            }
        } else {
            callback(result: self.locations, errorString: nil)
        }
    }
    
    func postStudentLocation(studentLocation: StudentLocation, callback: (success: Bool, errorString: String?) -> Void) {
        let urlString = "\(ParseClient.Constants.BaseURL)\(ParseClient.Methods.StudentLocation)"
        let jsonBody: String = "{\"uniqueKey\": \"\(studentLocation.uniqueKey)\", \"firstName\": \"\(studentLocation.firstName)\", \"lastName\": \"\(studentLocation.lastName)\",\"mapString\": \"\(studentLocation.mapString)\", \"mediaURL\": \"\(studentLocation.mediaURL)\",\"latitude\": \(studentLocation.latitude), \"longitude\": \(studentLocation.longitude)}"

        $.post(urlString).genericValues(auth).json(jsonBody).parseJSONWithCompletion(0) { (result, response, error) in
            if let err = error {
                callback(success: false, errorString: error.localizedDescription)
            } else {
                callback(success: true, errorString: nil)
            }
            
        }
    }
    
    // MARK: - Shared Instance
    class func sharedInstance() -> ParseClient {
        struct singleton {
            static var sharedInstance = ParseClient()
        }
        return singleton.sharedInstance
    }
}