//
//  SelfCheckTextField.swift
//  WNCS
//
//  Created by Above on 12/04/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

@IBDesignable
class SelfCheckTextField: UITextField {

    var border: CALayer!
    var error: NSError?
    @IBInspectable var errorColor: UIColor = UIColor(red: (245.0/255.0), green: (145.0/255.0), blue: (32.0/255.0), alpha: 1.0)
    @IBInspectable var normalColor: UIColor = UIColor.blackColor()
    @IBInspectable var regex: String?
    @IBInspectable var errorMessageForInvalidInput: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(SelfCheckTextField.validateText), forControlEvents: .EditingDidEnd)
        addTarget(self, action: #selector(SelfCheckTextField.clearError), forControlEvents: .EditingDidBegin)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addBottomBorderLine()
    }
    
    func addBottomBorderLine() {
        
        let frame = self.frame
        let borderWidth:CGFloat = 1
        
        if border == nil {
            border = CALayer()
            border.borderColor = UIColor.clearColor().CGColor
            border.borderWidth = borderWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
        
        border.frame = CGRectMake(5, frame.size.height - borderWidth, frame.size.width - 10, frame.size.height)
    }
    
    func highlightError(error:Bool) {
//        self.border.borderColor = (error) ? errorColor.CGColor : UIColor.clearColor().CGColor
        self.textColor = (error) ? errorColor : normalColor
    }
    
    func clearError() {
        error = nil
        highlightError(false)
    }

    func validateText() {
        //validate text
        if let regex = regex where regex.length() > 0 {
            var isInvalid = false
            if let text = self.text {
                isInvalid = text.length() > 0 && !text.isValidForRegex(regex)
            }

            highlightError(isInvalid)
            
            if isInvalid {
                //setup Error
                error = NSError.errorWithTitle("Invalid", details: errorMessageForInvalidInput ?? "Invalid input")
                
                //if error animate it
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.05
                animation.repeatCount = 2
                animation.autoreverses = true
                animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 2.0, self.center.y))
                animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x + 2.0, self.center.y))
                self.layer.addAnimation(animation, forKey: "position")
            } else {
                error = nil
            }
        }
    }
}

extension SelfCheckTextField {
    class func errorFromTextInput(fields: [UIView]) -> NSError? {
        for textField in fields {
            if let textField = textField as? SelfCheckTextField {
                if textField.error != nil {
                    return textField.error
                }
            }
        }
        return nil
    }
}
