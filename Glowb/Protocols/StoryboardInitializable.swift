//
//  StoryboardInitializable.swift
//
//  Created by Bogdan Vitoc on 7/5/16.
//  Copyright © 2016 Bogdan Vitoc. All rights reserved.
//

import UIKit

/// Assumes `Self` is the initial view controller of the storyboard
public protocol StoryboardInitializable: class {
    static var storyboardName: StaticString { get }
}

extension StoryboardInitializable where Self: UIViewController {
    public static func initFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName.description, bundle: nil)
        
        return storyboard.instantiateInitialViewController() as! Self
    }
}
