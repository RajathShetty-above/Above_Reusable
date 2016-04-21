//
//  PushAnimator.swift
//  ReusableSample
//
//  Created by Rajath K Shetty on 14/04/16.
//  Copyright © 2016 Above Solution. All rights reserved.
//

import UIKit

class PushAnimator: NSObject {

    var isPushing: Bool = true
    weak var navigationDelegate: UINavigationControllerDelegate?
    
    class func pushController(controller: UIViewController, fromController: UIViewController) -> PushAnimator {
        let animator = PushAnimator()
        controller.modalPresentationStyle = .Custom
        if let delegate = controller.navigationController?.delegate {
            animator.navigationDelegate = delegate
        }
        
        controller.navigationController?.delegate = animator
        fromController.navigationController?.pushViewController(controller, animated: true)
        return animator;
    }
}

extension PushAnimator: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        navigationDelegate?.navigationController?(navigationController, willShowViewController: viewController, animated: animated)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        navigationDelegate?.navigationController?(navigationController, didShowViewController: viewController, animated: animated)
    }
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return navigationDelegate?.navigationControllerSupportedInterfaceOrientations?(navigationController) ?? .All
    }

    func navigationControllerPreferredInterfaceOrientationForPresentation(navigationController: UINavigationController) -> UIInterfaceOrientation {
        return navigationDelegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController) ?? .Portrait
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self;
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension PushAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toView = toViewController.view
        let fromView = fromViewController.view
        let containerView = transitionContext.containerView()
        let duration = self .transitionDuration(transitionContext)
        
        if isPushing {
            toView.transform = CGAffineTransformMakeScale(0, 0)
            toView.alpha = 0.0
            containerView?.addSubview(toView)
            UIView.animateWithDuration(duration, animations: { () -> Void in
                toView.transform = CGAffineTransformIdentity
                toView.alpha = 1.0
                }, completion: { (success) -> Void in
                    transitionContext.completeTransition(success)
            })
            
        } else {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                fromView.transform = CGAffineTransformMakeScale(0, 0)
                toView.alpha = 0.0
                }, completion: { (success) -> Void in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(success)
            })
        }
    }
}

extension PushAnimator: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
