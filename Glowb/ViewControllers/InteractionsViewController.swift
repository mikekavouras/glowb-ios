//
//  InteractionsViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/8/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class InteractionsViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupCollectionView()
        registerForPreviewing(with: self, sourceView: collectionView)
        
        // eager load
        let _ = InteractionViewController.initFromStoryboard()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    
        collectionView.register(cellType: AddInteractionCollectionViewCell.self)
//        collectionView.register(InteractionCollectionViewCell.Nib, forCellWithReuseIdentifier: InteractionCollectionViewCell.CellIdentifier)
    }
    
    
    // MARK: Navigation
    
    fileprivate func displayInteractionViewController() {
        let viewController = InteractionViewController.initFromStoryboard()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
}


// MARK: - Collection view data source

extension InteractionsViewController: UICollectionViewDataSource {
    
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusable(cellType: AddInteractionCollectionViewCell.self, forIndexPath: indexPath)
    }
}


// MARK: - Collection view delegate

extension InteractionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayInteractionViewController()
    }
}


// MARK: - Collection view flow layout

extension InteractionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    
}

// MARK: - Previewing context delegate

extension InteractionsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let _ = collectionView.indexPathsForSelectedItems,
            let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) else {
                return nil
        }
        
        return nil
//        guard indexPath.row != User.currentUser.interactions.count else { return nil }
//        
//        previewingContext.sourceRect = cell.frame
//        let viewController = HeartViewController(nibName: HeartViewController.nibName(), bundle: nil)
//        viewController.preferredContentSize = CGSize(width: view.frame.size.width - 30, height: view.frame.size.width - 30)
//        
//        User.currentUser.interactions[indexPath.row].activate()
//        
//        return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {}
    
    
}


// MARK: - Scroll view delegate

extension InteractionsViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if let cells = collectionView.visibleCells as? [InteractionCollectionViewCell] {
//            for cell in cells {
//                cell.resetScroll()
//            }
//        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView == collectionView && scrollView.contentOffset.x < -70 {
//            performSegue(withIdentifier: "SettingsSegueIdentifier", sender: self)
//        }
    }
}