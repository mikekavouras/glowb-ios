//
//  RelationshipsViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/8/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class RelationshipsViewController: BaseViewController,
    UICollectionViewDelegate {

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
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.register(NewRelationshipCollectionViewCell.Nib, forCellWithReuseIdentifier: NewRelationshipCollectionViewCell.CellIdentifier)
//        collectionView.register(RelationshipCollectionViewCell.Nib, forCellWithReuseIdentifier: RelationshipCollectionViewCell.CellIdentifier)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: Navigation
    
    fileprivate func displayNewRelationshipViewController() {
//        if let viewController = storyboard?.instantiateViewController(withIdentifier: RelationshipTableViewController.StoryboardIdentifier) as? RelationshipTableViewController
//        {
//            viewController.presentedModally = true
//            let navigationController = UINavigationController(rootViewController: viewController)
//            present(navigationController, animated: true, completion: nil)
//        }
    }
}


extension RelationshipsViewController: UICollectionViewDataSource {
    
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == User.currentUser.relationships.count {
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewRelationshipCollectionViewCell.CellIdentifier, for: indexPath) as? NewRelationshipCollectionViewCell {
//                
//                cell.newItemButtonTappedHandler = { [unowned self] in
//                    self.displayNewRelationshipViewController()
//                }
//                
//                return cell
//            }
//        } else {
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelationshipCollectionViewCell.CellIdentifier, for: indexPath) as? RelationshipCollectionViewCell {
//                
//                let relationship = User.currentUser.relationships[indexPath.row]
//                cell.relationship = relationship
//                return cell
//            }
//        }
//        
        return UICollectionViewCell()
    }
    
    
}


// MARK: - Collection view flow layout

extension RelationshipsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    
}

// MARK: - Previewing context delegate

extension RelationshipsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let _ = collectionView.indexPathsForSelectedItems,
            let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) else {
                return nil
        }
        
        return nil
//        guard indexPath.row != User.currentUser.relationships.count else { return nil }
//        
//        previewingContext.sourceRect = cell.frame
//        let viewController = HeartViewController(nibName: HeartViewController.nibName(), bundle: nil)
//        viewController.preferredContentSize = CGSize(width: view.frame.size.width - 30, height: view.frame.size.width - 30)
//        
//        User.currentUser.relationships[indexPath.row].activate()
//        
//        return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {}
    
    
}


// MARK: - Scroll view delegate

extension RelationshipsViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if let cells = collectionView.visibleCells as? [RelationshipCollectionViewCell] {
//            for cell in cells {
//                cell.resetScroll()
//            }
//        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionView && scrollView.contentOffset.x < -70 {
            performSegue(withIdentifier: "SettingsSegueIdentifier", sender: self)
        }
    }
}
