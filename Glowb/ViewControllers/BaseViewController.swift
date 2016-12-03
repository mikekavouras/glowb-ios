//
//  BaseViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/3/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        view = BaseView(frame: CGRect.zero)
    }

}
