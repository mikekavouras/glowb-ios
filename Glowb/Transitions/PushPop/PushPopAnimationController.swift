//
//  PushPopAnimationController.swift
//  Glowb
//
//  Created by Michael Kavouras on 3/12/17.
//  Copyright © 2017 Michael Kavouras. All rights reserved.
//

import Foundation
import UIKit

enum PushPopAnimationControllerState {
    case push
    case pop
}

class PushPopAnimationController: NSObject,  UIViewControllerAnimatedTransitioning {
    
    private var state: PushPopAnimationControllerState = .push
    
    init(state: PushPopAnimationControllerState = .push) {
        self.state = state
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.40
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if state == .push {
            push(transitionContext)
        } else {
            pop(transitionContext)
        }
    }
    
    private func push(_ context: UIViewControllerContextTransitioning) {
        guard let toViewController = context.viewController(forKey: .to),
            let fromViewController = context.viewController(forKey: .from) else { return }
        
        
        context.containerView.addSubview(toViewController.view)
        
        let width = context.containerView.frame.size.width
        toViewController.view.frame.origin.x = width
        
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
            toViewController.view.frame.origin.x = 0
            fromViewController.view.frame.origin.x = -width
        }) { _ in
            context.completeTransition(true)
        }
    }
    
    private func pop(_ context: UIViewControllerContextTransitioning) {
        guard let toViewController = context.viewController(forKey: .to),
            let fromViewController = context.viewController(forKey: .from) else { return }
        
        let width = context.containerView.frame.size.width
        context.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        toViewController.view.frame.origin.x = -width
        
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                toViewController.view.frame.origin.x = 0
                fromViewController.view.frame.origin.x = width
        }) { _ in
            context.completeTransition(true)
        }
    }
}
