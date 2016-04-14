	//
//  SearchResponse.swift
//  UnitTest
//
//  Created by Rajath Shetty on 25/02/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit
    /**
     This is the base model for all the classes.
     All the classes should be subclass of model.
    */
    class BaseModel: NSObject {
        required init(json: JSON) {
            super.init()
        }
    }
    
    /**
     This will encapsulate all news data.
    */
    class News: BaseModel {
        
        let title: String
        let content: String
        let link: String
        let url: String
        
        required init(json: JSON) {
            title =  json["title"].string ?? ""
            content = json["contentSnippet"].string ?? ""
            link = json["link"].string ?? ""
            url = json["url"].string ?? ""
            
            super.init(json: json)
        }
        
        class func instanseFromArray(list: [JSON]) -> [News] {
            
            var newsItems: [News] = []
            for newsDictionary in list {
                let news = News(json: newsDictionary)
                newsItems.append(news)
            }
            return newsItems
        }
    }
    
    
    /**
     This is the class encapsulate all response data of search response
    */
    class SearchResponse: BaseModel {
        
        var searchText: String = ""
        var responseEntries: [News]? = nil
        
        required init(json: JSON) {
            let responseData = json["responseData"].dictionary
            if let responseData = responseData {
                searchText = responseData["query"]?.string ?? ""
                if let list = responseData["entries"]?.array {
                    responseEntries = News.instanseFromArray(list)
                }
            }
            
            super.init(json: json)
        }
        
    }
