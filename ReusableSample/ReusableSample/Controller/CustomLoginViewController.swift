//
//  CustomLoginViewController.swift
//  ReusableSample
//
//  Created by Samrajni on 16/03/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

class CustomLoginViewController: KeyboardViewController {

    var animator: RevealAnimator?
    
    @IBAction func login(sender: UIButton) {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.redColor()
        let animator = RevealAnimator.animator()
        self.animator = animator
        animator.revealType = .Right
        animator.presentController(controller, fromController: self)
    }
    
    @IBAction func signInButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func forgotPasswordButtonTapped(sender: UIButton) {
        
    }
}
