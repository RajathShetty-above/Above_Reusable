//
//  UIApplicationExtension.swift
//  ReusableSample
//
//  Created by Rajath Shetty on 14/03/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func currentSize() -> CGSize {
        return UIApplication.sizeInOrientation(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    class func sizeInOrientation(orientation: UIInterfaceOrientation) -> CGSize {
        var size = UIScreen.mainScreen().bounds.size
        let application = UIApplication.sharedApplication()
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            size = CGSizeMake(size.height, size.width)
        }
        
        if (!application.statusBarHidden) {
            size.height -= min(application.statusBarFrame.size.width, application.statusBarFrame.size.height)
        }
        return size;
    }
    
    class func getRootViewController() -> UIViewController? {
        var presentedVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        
        return presentedVC
    }
}

