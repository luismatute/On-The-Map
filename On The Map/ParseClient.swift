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
    
    // MARK: - Class Properties
    override init() {
        super.init()
    }
    
    // MARK: - Convinience
    func getStudentLocations(callback: (result: [StudentLocation]?, errorString: String?) -> Void) {
        let parameters = [ParameterKeys.Limit: 100]
        let mutableParameters = $.escapedParameters(parameters)
        let urlString = "\(ParseClient.Constants.BaseURL)\(ParseClient.Methods.StudentLocation)" + mutableParameters
        var le_results = [StudentLocation]()
        
        $.get(urlString).genericValues(auth).parseJSONWithCompletion(0) { (result, response, error) in
            println(result)
            println(error)
            println(response)
            if let error = error {
                callback(result: nil, errorString: "Error")
            } else {
                if let results = result.valueForKey(JSONResponseKeys.Results) as? [[String : AnyObject]] {
                    var locations = StudentLocation.studentLocationFromResults(results)
                    callback(result: locations, errorString: nil)
                } else {
                    callback(result: nil, errorString: "No Results Found")
                }
            }
        }
    }
    
    func postStudentLocation(studentLocation: StudentLocation, callback: (success: Bool, errorString: String) -> Void) {
        let urlString = "\(ParseClient.Constants.BaseURL)\(ParseClient.Methods.StudentLocation)"
        
        $.post(urlString).genericValues(auth).parseJSONWithCompletion(0) { (result, response, error) in
            println(result)
            println(error)
            println(response)
        }
    }
    
    func putStudentLocation(studentLocation: StudentLocation, callback: (success: Bool, errorString: String) -> Void) {}
    
    func queryStudentLocation(studentLocation: StudentLocation, callback: (success: Bool, errorString: String) -> Void) {}
    
    // MARK: - Shared Instance
    class func sharedInstance() -> ParseClient {
        struct singleton {
            static var sharedInstance = ParseClient()
        }
        return singleton.sharedInstance
    }
}