//
//  InteractionCollectionViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/13/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class InteractionCollectionViewCell: BaseCollectionViewCell, ReusableView {
    
    var editButtonTappedHandler: (() -> Void)?
    
    static var identifier: String = "InteractionCellIdentifier"
    static var nibName: String = "InteractionCollectionViewCell"
    
    
    @IBOutlet weak var nameLabel: PrimaryTextLabel!
    @IBOutlet private weak var editButton: UIButton!
    
    fileprivate let outOfFocusVisibleHeight: CGFloat = 60.0
    fileprivate let cornerRadius: CGFloat = 20.0

    @IBOutlet weak var backgroundContainerView: BaseView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var scrollContentView: UIView!
    @IBOutlet weak private var scrollContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var scrollContentViewWidthConstraint: NSLayoutConstraint!
    
    private var isSkrilt: Bool {
        return scrollView.contentOffset.y == 0
    }
    
    fileprivate lazy var foregroundView: BaseView = {
        let view = BaseView()
        view.theme = .dark
        view.layer.cornerRadius = self.cornerRadius
        view.clipsToBounds = true
        
        view.addSubview(self.foregroundImageView)
        view.addSubview(self.foregroundOverlayView)
        self.foregroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.foregroundOverlayView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        return view
    }()
    
    fileprivate lazy var foregroundOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        
        return view
    }()
    
    lazy var foregroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    fileprivate lazy var shadowView: UIView = {
        let v = UIView()
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        v.layer.shadowOpacity = 0.32
        v.layer.shadowRadius = 12.0
        v.backgroundColor = .black
        v.layer.cornerRadius = self.cornerRadius
        return v
    }()
    
    
    // MARK: Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundContainerView.layer.cornerRadius = cornerRadius
        backgroundContainerView.clipsToBounds = true
        
        backgroundBlurView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        backgroundImageView.alpha = 0.45
        
        scrollContentView.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in 
            make.height.equalTo(contentView)
            make.left.bottom.right.equalTo(scrollContentView)
        }
        
        scrollContentView.addSubview(foregroundView)
        foregroundView.snp.makeConstraints { make in
            make.height.equalTo(contentView)
            make.left.bottom.right.equalTo(scrollContentView)
        }
        
        scrollView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(gesture:)))
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc private func scrollViewTapped(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: contentView)
        if editButton.frame.contains(point) && isSkrilt {
            editButtonTappedHandler?()
        }
    }
    
    var firstAppearance = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if firstAppearance {
            firstAppearance = false
            
            
            scrollContentViewWidthConstraint.constant = frame.size.width
            scrollContentViewHeightConstraint.constant = frame.size.height * 2.0 - outOfFocusVisibleHeight
            
            scrollView.contentSize = scrollContentView.frame.size
        }
        
        scrollView.contentOffset = CGPoint(x: 0, y: frame.size.height - outOfFocusVisibleHeight)
    }
}


// MARK: - Scroll view delegate

extension InteractionCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = (scrollView.contentOffset.y + outOfFocusVisibleHeight) / frame.size.height
        
        foregroundOverlayView.alpha = (1 - alpha) * 0.8
        backgroundContainerView.alpha = min(0.99, 1 - alpha)
    }
}
