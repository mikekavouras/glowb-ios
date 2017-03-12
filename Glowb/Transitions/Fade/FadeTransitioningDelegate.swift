//
//  CardTransitioningDelegate.swift
//  CardNavigation
//
//  Created by Mike Kavouras on 10/16/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

class FadeTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    static let shared = FadeTransitioningDelegate()
    
    private override init() {
        super.init()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimationController(dismissing: true)
    }
    
}
