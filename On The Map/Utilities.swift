//
//  utilities.swift
//  On The Map
//
//  Created by Luis Matute on 5/26/15.
//  Copyright (c) 2015 Luis Matute. All rights reserved.
//

import UIKit

class $ {
    let request : NSMutableURLRequest
    
    init(httpMethod: String, endpointURL: String, httpHeaders: Dictionary<String, String>?) {
        let url = NSURL(string: endpointURL)
        request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = httpMethod
        
        if let httpHeadersUnWrapped = httpHeaders {
            request.allHTTPHeaderFields = httpHeadersUnWrapped
        }
    }
    
    // MARK: - HTTP
    class func post(url: String) -> $ {
        return $(httpMethod: "POST", endpointURL: url, httpHeaders: nil)
    }
    class func get(url: String) -> $ {
        return $(httpMethod: "GET", endpointURL: url, httpHeaders: nil)
    }
    class func delete(url: String) -> $ {
        return $(httpMethod: "DELETE", endpointURL: url, httpHeaders: nil)
    }
    
    func headers(headers: Dictionary<String,String>) -> $ {
        request.allHTTPHeaderFields = headers
        return self
    }
    func body(httpBody: NSData) -> $ {
        request.HTTPBody = httpBody
        return self
    }
    func form(dict: Dictionary<String,String>) -> $ {
        let postData:NSData = prepareForm(dict)
        request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        return self
    }
    func json(jsonString:String) -> $ {
        let postData:NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        return self
    }
    func cookies() -> $ {
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        return self
    }
    func genericValues(dict: [String:String]) -> $ {
        for (val,head) in dict {
            self.request.addValue(val, forHTTPHeaderField: head)
        }
        return self
    }
    
    // MARK: - Completion Handlers
    func parseJSONWithCompletion(removeCharsCount: Int, completion: (result: AnyObject!, response: NSURLResponse!, error: NSError!) -> ()) -> () {
        var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task = session.dataTaskWithRequest(self.request) { data, response, downloadError in
            if let err = downloadError {
                completion(result: nil, response: response, error: err)
            } else {
                var parsingError: NSError? = nil
                
                let newData = data.subdataWithRange(NSMakeRange(removeCharsCount, data.length - removeCharsCount))
                
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String : AnyObject]
                
                if let error = parsingError {
                    completion(result: nil, response: response, error: error)
                } else {
                    completion(result: parsedResult, response: response, error: nil)
                }
            }
        }
        
        task.resume()
    }
    func completion(completion: (data: NSData!, response: NSURLResponse!, error: NSError!) -> ()) -> () {
        var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        session.dataTaskWithRequest(self.request, completionHandler: completion).resume()
    }
    
    // MARK: - Helpers
    private func prepareForm(dict: Dictionary<String,String>) -> NSData {
        let frames:NSMutableArray = NSMutableArray()
        for (key, value) in dict {
            let encodedString:String = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
            frames.addObject(("\(key)=\(encodedString)"))
        }
        let postData:NSData = frames.componentsJoinedByString("&").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        return postData
    }
    class func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        
        for (key, value) in parameters {
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }

}