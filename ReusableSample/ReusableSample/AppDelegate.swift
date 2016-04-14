//
//  AppDelegate.swift
//  ReusableSample
//
//  Created by Rajath Shetty on 04/03/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        ABSocialManager.sharedInstance.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Override point for customization after application launch.
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        ABSocialManager.sharedInstance.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return ABSocialManager.sharedInstance.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}

