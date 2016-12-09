//
//  CardAnimationController.swift
//  CardNavigation
//
//  Created by Mike Kavouras on 10/15/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

class CardAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var dismissing = false
    
    init(dismissing: Bool = false) {
        self.dismissing = dismissing
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return dismissing ? 0.5 : 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if dismissing {
            hideCard(using: transitionContext)
        } else {
            showCard(using: transitionContext)
        }
    }
    
    private func showCard(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        toViewController.view.layer.shadowColor = UIColor.black.cgColor
        toViewController.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        toViewController.view.layer.shadowOpacity = 0.84
        toViewController.view.layer.shadowRadius = 10.0
        toViewController.view.layer.cornerRadius = 12.0
        toViewController.view.layer.masksToBounds = true
        
        toViewController.view.alpha = 0.0
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            toViewController.view.alpha = 0.7
        }) { done in
            transitionContext.completeTransition(true)
        }
    }
    
    private func hideCard(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else
        { return }
        
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            fromViewController.view.frame.origin.y = toViewController.view.bounds.size.height
        }) { done in
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(true)
        }
    }
    
}
