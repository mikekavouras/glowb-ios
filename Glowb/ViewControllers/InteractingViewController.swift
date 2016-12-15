//
//  InteractingViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/14/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import SnapKit

class InteractingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let imageView = UIImageView(image: #imageLiteral(resourceName: "heart"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}
