//
//  NSErrorExtension.swift
//  JiyoPublisher
//
//  Created by Rajath Shetty on 24/03/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

extension NSError {
    class func errorWithTitle(title: String, details: String) -> NSError {
        return errorWithCode(0, title: title, details: details)
    }
    
    class func errorWithCode(code: Int, title: String, details: String) -> NSError {
        return NSError(domain: title, code: code, userInfo: [NSLocalizedDescriptionKey : details])
    }
}