//
//  StringExtension.swift
//  UnitTestSample
//
//  Created by Rajath Shetty on 25/02/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import Foundation

extension String {
    func percentEncoding() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return isValidForRegex(emailRegex)
    }
    
    func isValidMobileNumber() -> Bool {
        let phoneRegex = "([+]?([0-9]{1,2})[-]?)?[0-9]{10}"
        return isValidForRegex(phoneRegex)
    }
    
    func isValidForRegex(regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluateWithObject(self)
    }
    
    func length() -> Int {
        return self.characters.count
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        return self.stringByAppendingString("/"+path)
    }
    
    func encodeEmoji() -> String? {
        let data = self.dataUsingEncoding(NSNonLossyASCIIStringEncoding)
        if let data = data, finalString = NSString(data:data, encoding:NSUTF8StringEncoding) as? String {
            return finalString
        } else {
            return nil
        }
    }
    
    func decodeEmoji() -> String? {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        if let data = data, finalString = NSString(data:data, encoding:NSNonLossyASCIIStringEncoding) as? String {
            return finalString
        } else {
            return nil
        }
    }
}

prefix operator <<< { }

prefix func <<<(right: String) -> String {
    return NSLocalizedString(right, comment: "")
}