//
//  CustomLoginViewController.swift
//  ReusableSample
//
//  Created by Samrajni on 16/03/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

class CustomLoginViewController: KeyboardViewController {

    func loadNextViewController() {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.redColor()
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func signInButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func forgotPasswordButtonTapped(sender: UIButton) {
        
    }
}
