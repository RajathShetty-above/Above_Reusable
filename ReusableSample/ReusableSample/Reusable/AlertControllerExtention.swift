//
//  AlertControllerExtention.swift
//  ReusableSample
//
//  Created by Rajath Shetty on 04/03/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

/**
 Add more flexibility to show alert easily.
*/
extension UIAlertController {
    
    typealias ActionHandler = (UIAlertController, UIAlertAction) -> Void

    //MARK: Alert show messages
    
    /**
    Present alert controller with message and "Ok" button to dismiss alert.
    
    - Parameter message: Message to display in alert
    */
    class func showAlertWithMessage(message: String) {
        showAlertWithMessage(message, title: nil)
    }
    
    /**
     Present alert controller with message, title and "Ok" button to dismiss alert.
     
     - Parameters:
        - message: Message to display in alert.
        - title  : Title for alert, it is optional.
     */
    class func showAlertWithMessage(message: String, title: String?) {
        showAlertWithMessage(message, title: title, cancelButtonTitle: "OK",handler: nil)
    }
    
    /**
     Present alert controller with message, title and one action button.
     
     - Parameters:
        - message           : Message to display in alert.
        - title             : Title for alert, it is optional.
        - cancelButtonTitle : Action button title, cannot be nil.
        - handler           : Handler for action button, passing nil provide default action. i.e dismiss alert.
     */
    class func showAlertWithMessage(message: String, title: String?, cancelButtonTitle: String, handler: ActionHandler?) {
        let alertController = alertControllerWithMessage(message, title: title)
        alertController.addActionWithTitle(cancelButtonTitle, style: .Default, handler: handler)
        alertController.show()
    }
    
    /**
     Present alert controller with one action button and cancel button.
     */
    class func showAlertWithMessage(message: String, title: String?, actionButtonTitle: String, cancelButtonTitle: String, actionButtonHandler: ActionHandler?, cancelButtonHandler: ActionHandler?) {
        let alertController = alertControllerWithMessage(message, title: title)
        alertController.addActionWithTitle(actionButtonTitle, style: .Default, handler: actionButtonHandler)
        alertController.addActionWithTitle(cancelButtonTitle, style: .Cancel, handler: cancelButtonHandler)
        alertController.show()
    }
    
    /**
     Present alert controller with one action button and destructive button.
     */
    class func showAlertWithMessage(message: String, title: String?, actionButtonTitle: String, destructiveButtonTitle: String, actionButtonHandler: ActionHandler?, destructiveButtonHandler: ActionHandler?) {
        let alertController = alertControllerWithMessage(message, title: title)
        alertController.addActionWithTitle(actionButtonTitle, style: .Default, handler: actionButtonHandler)
        alertController.addActionWithTitle(destructiveButtonTitle, style: .Destructive, handler: destructiveButtonHandler)
        alertController.show()
    }
    
    //MARK: Creates Alert controller
    /**
    Creates and return alert controller with message.
    
    - Returns: created alert controller.
    */
    class func alertControllerWithMessage(message: String) -> UIAlertController {
        return alertControllerWithMessage(message, title: nil)
    }
    
    /**
     Creates and return alert controller with message and title.
     
     - Returns: created alert controller.
     */
    class func alertControllerWithMessage(message: String, title: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .Alert)
    }
    
    //MARK: Add actions methods
    /**
    Add button to alert view controller.
    
    - Returns: Created alert action.
    */
    func addActionWithTitle(title: String, style: UIAlertActionStyle, handler: ActionHandler? ) -> UIAlertAction {
        
        //create new handler, which support by built in method.
        var actionHandler: ((UIAlertAction) -> Void)? = nil
        if let handler = handler {
            actionHandler = { [weak self] (sender: UIAlertAction) -> Void in
                if let weakSelf = self {
                    handler(weakSelf, sender)
                }
            }
        }
        
        let action: UIAlertAction = UIAlertAction(title: title, style: style, handler: actionHandler)
        self.addAction(action)
        return action
    }
    
    //MARK: Show alert
    
    /**
    Present alert view controller, if controller view is not in view hierarchy.
    */
    func show() {
        
        //Present only if it is not in hierarchy
        if self.view.window == nil {
            let presenter = getRootViewController()
            presenter?.presentViewController(self, animated: true, completion: nil)
        }
    }
}

private extension UIAlertController {
    
    /**
     Returns root view controller of application
     */
    func getRootViewController() -> UIViewController? {
        var presentedVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        
        return presentedVC
    }
}
