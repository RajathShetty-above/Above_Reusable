//
//  KeyboardViewController.swift
//  ReusableSample
//
//  Created by Rajath Shetty on 16/03/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

/**
 This will maintain login state of the user.
 */
enum FormValidationState: Int {
    case Empty
    case PartiallyFilled
    case CompleteFilled
    case Successful
    
    func isSubmitButtonEnabled() -> Bool {
        return self == .CompleteFilled ? true : false
    }
    
    func returnKeyType() -> UIReturnKeyType {
        switch self {
        case .Empty:
            return .Next
        case .PartiallyFilled:
            return .Next
        case .CompleteFilled:
            return .Go
        case .Successful:
            return .Go
        }
    }
}

/**
 This will manage all keyboard related tasks. The structure of view should be,
 
 */
class KeyboardViewController: UIViewController {
    
    @IBOutlet weak var rootContainerScrollView: UIScrollView!
    
    //Connect all textField and text view in order, as colection
    //This order is used to set next first responder, when user tap next in keyboard.
    @IBOutlet var orderedTextFields: [UIView]?
    
    //Set this property to first responder, to scroll to right position.
    weak var currentFirstResponder: UIView?
    var loginState: FormValidationState = .Empty
    weak var tapGesture: UITapGestureRecognizer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addKeyboardNotificationObserver()
    }
    
    deinit {
        removeKeyboardNotificationObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(self.rootContainerScrollView != nil, "You need to add scroll view on top, As a container to all your subviews.")
        
        if let orderedTextFields = orderedTextFields {
            for view in orderedTextFields {
                
                if let textfield = view as? UITextField {
                    textfield.delegate = self
                } else if let textView = view as? UITextView {
                    textView.delegate = self
                } else {
                    assert(self.rootContainerScrollView != nil, "orderedTextFields Should contain Text field or Text view")
                }
            }
        }
        
        //Add tap gestures
        if tapGesture == nil && rootContainerScrollView != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(KeyboardViewController.handleTapGesture(_:)))
            rootContainerScrollView.addGestureRecognizer(tapGesture)
            self.tapGesture = tapGesture
            tapGesture.numberOfTapsRequired = 1
        }
        
        updateLoginStatus()
    }
    
    /**
     Validate every text fields.
     This check is used to select next first responder.
     
     return always true, if that text field is optional.
     Override this method to implement all checks.
     */
    func validateTextFieldText(textField: UITextField) -> Bool {
        if let text = textField.text where text.characters.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    /**
     Validate every text view.
     This check is used to select next first responder.
     
     return always true, if that text field is optional.
     Override this method to implement all checks.
     */
    func validateTextViewText(textView: UITextView) -> Bool {
        if let text = textView.text where text.characters.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    /**
     This will compute correct login status for form filling.
     Override this method on your own risk,
     */
    func updateLoginStatus() {
        
        if (!computeTextFeildWithIntialValue(false, operation: {$0 || $1})) {
            loginState = .Empty
        } else if (!computeTextFeildWithIntialValue(true, operation: { $0 && $1})) {
            loginState = .PartiallyFilled
        } else if (computeTextFeildWithIntialValue(true, operation: { $0 && $1})) {
            loginState = .CompleteFilled
        } else {
            loginState = .Successful
        }
        
        setupViewForLoginState(loginState)
    }
    
    
    
    func updateResponderLoginState(loginState: FormValidationState) {
        
        switch loginState {
        case .Empty:
            if let view = orderedTextFields?[0] {
                view.becomeFirstResponder()
            }
        case .PartiallyFilled:
            if let orderedTextFields = orderedTextFields {
                let index = orderedTextFields.indexOf({ (view) -> Bool in
                    !validateView(view)
                })
                if let index = index {
                    orderedTextFields[index].becomeFirstResponder()
                }
            }
        default :
            if let orderedTextFields = orderedTextFields {
                for view in orderedTextFields {
                    view.resignFirstResponder()
                }
            }
        }
    }
    
    func setupViewForLoginState(loginState: FormValidationState)  {
        
    }
    
    //MARK: Custom methods
    func handleKeyboardAppearence(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                didHide(false, keyboardOfHeight: keyboardSize.height, textField: currentFirstResponder)
            }
        }
    }
    
    func handleKeyboardDisappearance(notification: NSNotification) {
        didHide(true, keyboardOfHeight: 0, textField: nil)
    }
    
    func handleTapGesture(gesture: UITapGestureRecognizer) {
        currentFirstResponder?.resignFirstResponder()
    }
}

private extension KeyboardViewController {
    
    func addKeyboardNotificationObserver() {
        //Add observer to get notification about keyboard.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardViewController.handleKeyboardAppearence(_:)), name: UIKeyboardDidShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardViewController.handleKeyboardDisappearance(_:)), name: UIKeyboardDidHideNotification , object: nil)
    }
    
    func removeKeyboardNotificationObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func didHide(hide: Bool, keyboardOfHeight height: CGFloat, textField: UIView?) {
        
        //Add scroll inset
        var inset: CGFloat = 0
        if !hide {
            inset = height
        }
        addBottomScrollInset(inset)
        
        //scroll to make that text field visible
        if let textField = textField where !hide {
            let textFieldBottomY = textField.convertPoint(CGPointMake(0, textField.bounds.origin.y), toView: nil).y
            let keyboardTopY = UIApplication.currentSize().height - height;
            if keyboardTopY < textFieldBottomY {
                self.rootContainerScrollView.scrollRectToVisible(textField.frame, animated: false)
            }
        }
    }
    
    func addBottomScrollInset(inset: CGFloat) {
        UIView.animateWithDuration(0, animations: { [weak self] () -> Void in
            self?.rootContainerScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
            self?.rootContainerScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
            }, completion: nil)
        
    }
    
    func validateView(view: UIView) -> Bool {
        if let textfield = view as? UITextField {
            return validateTextFieldText(textfield)
        } else if let textView = view as? UITextView {
            return validateTextViewText(textView)
        } else {
            return false
        }
    }
    
    func computeTextFeildWithIntialValue(value: Bool, operation: ((Bool, Bool) -> Bool) ) -> Bool {
        
        if let orderedTextFields = orderedTextFields {
            return orderedTextFields.reduce(value) { (result, view) -> Bool in
                operation(result, validateView(view))
            }
        } else {
            return false
        }
    }
    
    func returnKeyForKeyboard() -> UIReturnKeyType {
        var count = 0
        if let orderedTextFields = orderedTextFields {
            for view in orderedTextFields {
                if !validateView(view) {
                    count += 1
                }
            }
        }
        
        if count == 1 {
            let state = FormValidationState(rawValue: loginState.rawValue + 1)
            return state!.returnKeyType()
        }
        
        return loginState.returnKeyType()
    }
}

extension KeyboardViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        currentFirstResponder = textField
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        updateLoginStatus()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.returnKeyType = returnKeyForKeyboard()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        updateLoginStatus()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        updateLoginStatus()
        updateResponderLoginState(loginState)
        return true
    }
}

extension KeyboardViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        currentFirstResponder = textView
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        updateLoginStatus()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.returnKeyType = returnKeyForKeyboard()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        updateLoginStatus()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        updateLoginStatus()
        updateResponderLoginState(loginState)
        return true
    }
}
