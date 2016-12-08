//
//  CardTransitioningDelegate.swift
//  CardNavigation
//
//  Created by Mike Kavouras on 10/16/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

class CardTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    static let shared = CardTransitioningDelegate()
    
    private override init() {
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardAnimationController(dismissing: true)
    }
    
}
