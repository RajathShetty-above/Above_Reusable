//
//  ReusableSampleTests.swift
//  ReusableSampleTests
//
//  Created by Rajath Shetty on 04/03/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import XCTest
@testable import ReusableSample

extension JSON: ABTestSupport {
    
    func jsonParse(json: JSON, didReceiveNilValue value:AnyObject?, expectedType: Type)
    {
        
    }
    
    func jsonParse(json: JSON, didReceiveNullValue value:AnyObject?, expectedType: Type) {
        
    }
    
    func jsonParse(json: JSON, didReceiveDifferentTypeValue value:AnyObject?, expectedType: Type) {
        
        let description = unitTestErrorDescriptionForJson(json, value: value, expectedType: expectedType)
        XCTFail(description)
    }
    
}

class ReusableSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testGetNewsResponse() {
        RequestManager.sharedInstance.getNewsRelatedToQueryText("") { (response, error) -> Void in
            
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
