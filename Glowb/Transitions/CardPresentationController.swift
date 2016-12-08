//
//  CardPresentationController.swift
//  CardNavigation
//
//  Created by Mike Kavouras on 10/16/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import SnapKit

class CardPresentationController: UIPresentationController {
    
    static private let fromTop: CGFloat = 28.0
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds
        let contentContainer = presentedViewController
        
        presentedViewFrame.size = size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.y = CardPresentationController.fromTop
        presentedViewFrame.origin.x = 20.0
        
        return presentedViewFrame
    }
    
    private var dimmingView = UIView()
    
    
    // MARK: Presentations
    override func presentationTransitionWillBegin() {
        setupDimmingView()
        
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
        dimmingView.backgroundColor = UIColor.gray.withAlphaComponent(0.94)
        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        dimmingView.addGestureRecognizer(tap)
    }
    
    @objc private func dismiss() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissByStatusBarTap() {
        if presentedViewController.presentedViewController == nil {
            dismiss()
        }
    }
}
