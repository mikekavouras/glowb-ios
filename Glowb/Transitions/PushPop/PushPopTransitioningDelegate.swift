//
//  PushPopTransitioningDelegate.swift
//  Glowb
//
//  Created by Michael Kavouras on 3/12/17.
//  Copyright © 2017 Michael Kavouras. All rights reserved.
//

import UIKit

class PushPopTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    static let shared = PushPopTransitioningDelegate()
    
    private override init() {
        super.init()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushPopAnimationController(state: .push)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushPopAnimationController(state: .pop)
    }
    
}
