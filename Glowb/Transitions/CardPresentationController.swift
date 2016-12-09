//
//  CardPresentationController.swift
//  CardNavigation
//
//  Created by Mike Kavouras on 10/16/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import SnapKit
import SpriteKit

class CardPresentationController: UIPresentationController {
    
    static private let fromTop: CGFloat = 20.0
    
    private var dimmingView = UIView()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds
        let contentContainer = presentedViewController
        
        presentedViewFrame.size = size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.y = CardPresentationController.fromTop
        presentedViewFrame.origin.x = 20.0
        
        return presentedViewFrame
    }
    
    
    
    // MARK: Presentations
    override func presentationTransitionWillBegin() {
        setupDimmingView()
        setupGlowView()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        NotificationCenter.default.removeObserver(self, name: nil, object: nil)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width - 40, height: parentSize.height * 0.75)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        
    }
    
    // MARK: Setup
    private func setupDimmingView() {
        guard let containerView = containerView else { return }
        
        containerView.insertSubview(dimmingView, at: 0)
        
        dimmingView.alpha = 0.0
        dimmingView.backgroundColor = UIColor.black
        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let centerY = containerView.frame.size.height - (frameOfPresentedViewInContainerView.origin.y + frameOfPresentedViewInContainerView.height)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.alpha = 0.0
        button.setImage(#imageLiteral(resourceName: "cancelCircle"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.center = CGPoint(x: containerView.center.x, y: containerView.frame.size.height - (centerY / 2.0))
        
        dimmingView.addSubview(button)
        
        UIView.animate(withDuration: 0.6, delay: 1.0, options: .curveLinear, animations: {
            button.alpha = 0.4
        }, completion: nil)
    }
    
    private func setupGlowView() {
        guard let containerView = containerView else { return }
        
        let skView = SKView()
        let skScene = GlowScene(size: containerView.frame.size)
        skView.presentScene(skScene)
        
        dimmingView.insertSubview(skView, at: 0)
        skView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    @objc private func dismiss() {
        
        let cancelAction = UIAlertAction(title: "Cancel setup", style: .destructive) { action in
            self.presentingViewController.dismiss(animated: true, completion: nil)
        }
        
        let dismissAction = UIAlertAction(title: "Continue setup", style: .default, handler: nil)
        
        let alert = UIAlertController(title: "Cancel setup?", message: "Are you sure you want to cancel setup?", preferredStyle: .alert)
        alert.addAction(dismissAction)
        alert.addAction(cancelAction)
        
        (presentedViewController as! UINavigationController).topViewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc private func dismissByStatusBarTap() {
        if presentedViewController.presentedViewController == nil {
            dismiss()
        }
    }
}

