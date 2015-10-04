//
//  FacebookClient.swift
//  Eventer
//
//  Created by Sergey Krivov on 03.10.15.
//  Copyright © 2015 Sergey Krivov. All rights reserved.
//

import UIKit

class FacebookClient: NSObject {
    
    static let sharedInstance = FacebookClient()

    /* Shared session */
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGETMethod(urlString: String,
        completionHandler: (result: NSData?, error: NSError?) -> Void) {
            
            // Create the request
            let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            
            // Make the request
            let task = session.dataTaskWithRequest(request) {
                data, response, downloadError in
                
                if let error = downloadError {
                    
                    let newError = FacebookClient.errorForResponse(data, response: response, error: error)
                    completionHandler(result: nil, error: newError)
                } else {
                    
                    completionHandler(result: data, error: nil)
                }
            }
            
            task.resume()
    }
    
    func fbGraphSearchEvents(text: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        let parameters = [
            "q" : text,
            "type" : "event",
            "since" : "now",
            "until" : "next year",
            "limit" : 1000,
        ]
        
        FBSDKGraphRequest(graphPath: "/search", parameters: parameters as [NSObject : AnyObject]).startWithCompletionHandler { (connection, result, downloadError) -> Void in
            
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                completionHandler(result: result, error: nil)
            }
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError?
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        } catch {
            parsingError = NSError(domain: "Eventer", code: 400, userInfo: nil)
            parsedResult = nil
        }
        
        if let error = parsingError {
            
            completionHandler(result: nil, error: error)
        } else {
            
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            if(!key.isEmpty) {
                /* Make sure that it is a string value */
                let stringValue = "\(value)"
                
                /* Escape it */
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                
                /* Append it */
                urlVars += [key + "=" + "\(escapedValue!)"]
            }
            
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    //get error for response
    class func errorForResponse(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = (try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as? [String : AnyObject] {
            
            if let result = parsedResult[JSONResponseKeys.Result]  as? String,
                message = parsedResult[JSONResponseKeys.Message] as? String {
                    
                    if result == JSONResponseValues.Fail {
                        
                        let userInfo = [NSLocalizedDescriptionKey: message]
                        
                        return NSError(domain: "Eventer Error", code: 1, userInfo: userInfo)
                    }
            }
        }
        return error
    }
}
