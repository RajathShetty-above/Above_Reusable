//
//  RequestManager.swift
//  UnitTest
//
//  Created by Rajath Shetty on 25/02/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

//This class will manage all request 
class RequestManager: NSObject {
    
    let searchBaseURL = "https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q="
    
    static let sharedInstance = RequestManager()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    func validateSearchString(text: String) -> Bool {
        if text.characters.count == 0 {
            return false
        }
        
        return true
    }
    
    func urlToGetNewsWithQueryText(queryText: String?) -> NSURL? {
        if let queryText = queryText where queryText.characters.count > 0{
            var requestUrlString: String? = searchBaseURL + "\(queryText)"
            requestUrlString = requestUrlString?.percentEncoding()
            if let requestUrlString = requestUrlString, requestUrl = NSURL(string: requestUrlString) {
                return requestUrl
            }
        }
        
        return nil
    }
    
    func requestUrl(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(data, response, error)
            })
            
        }).resume()
    }
    
    func getNewsRelatedToQueryText(queryText: String?, completionHandler: ((response: SearchResponse?, error: NSError?) -> Void)) {
        if let requestUrl = urlToGetNewsWithQueryText(queryText) {
            self.requestUrl(requestUrl, completionHandler: { (data, response, error) -> Void in
                if let data = data where error == nil {
                    let json = JSON(data: data)
                    let finalResponse = SearchResponse(json: json)
                    completionHandler(response: finalResponse, error: nil)
                } else {
                    completionHandler(response: nil, error: error)
                }
            })
        } else {
            completionHandler(response: nil, error: NSError(domain: "Invalid Url", code: 0, userInfo: nil))
        }
    }
}
