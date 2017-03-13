//
//  CardAnimationController.swift
//  CardNavigation
//
//  Created by Mike Kavouras on 10/15/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

class FadeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var dismissing = false
    
    init(dismissing: Bool = false) {
        self.dismissing = dismissing
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if dismissing {
            fadeOut(using: transitionContext)
        } else {
            fadeIn(using: transitionContext)
        }
    }
    
    private func fadeIn(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        toViewController.view.alpha = 0.0
        
        let blurView = UIVisualEffectView()
        containerView.insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.insertSubview(overlayView, aboveSubview: blurView)
        overlayView.alpha = 0.0
        overlayView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            blurView.effect = UIBlurEffect(style: .dark)
            overlayView.alpha = 0.0
            toViewController.view.alpha = 1.0
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    private func fadeOut(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else
        { return }
        
        let blurView = transitionContext.containerView.subviews.filter { $0 is UIVisualEffectView }.first
        let overlayView = transitionContext.containerView.subviews.filter { !($0 is UIVisualEffectView) && $0 != fromViewController.view }.first
        let duration = transitionDuration(using: transitionContext)
        
        toViewController.beginAppearanceTransition(true, animated: true)
        
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0.0
            (blurView as? UIVisualEffectView)?.effect = nil
            overlayView?.alpha = 0.0
        }) { _ in
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(true)
        }
    }
    
}
