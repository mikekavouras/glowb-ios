//
//  InteractionsViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/8/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import AlamofireImage

class InteractionsViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        User.current.fetchInteractions().then { _ in 
            self.collectionView.reloadData()
        }.catch { error in
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupCollectionView()
        setupForceTouch()
        
        // eager load
        let _ = InteractionViewController.initFromStoryboard()
    }
    
    private func setupForceTouch() {
        registerForPreviewing(with: self, sourceView: collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    
        collectionView.register(cellType: AddInteractionCollectionViewCell.self)
        collectionView.register(cellType: InteractionCollectionViewCell.self)
    }
    
    
    // MARK: Navigation
    
    fileprivate func displayInteractionViewController(_ interaction: Interaction? = nil) {
        let viewController = InteractionViewController.initFromStoryboard()
        viewController.interaction = interaction
        let navigationController = BaseNavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    fileprivate func displayShareAction(_ interaction: Interaction) {
        guard let id = interaction.id else { return }
        Share.create(interactionId: id).then { share in
            self.displayActivitySheet(share: share)
        }.catch { error in
                print(error)
        }
    }
    
    private func displayActivitySheet(share: Share) {
        let text = "Glow me!"
        let activityItems = [text as AnyObject, share.url as AnyObject]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    // MARK: - Action
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let viewController = SettingsViewController()
        let navController = BaseNavigationController(rootViewController: viewController)
        present(navController, animated: true, completion: nil)
    }
}


// MARK: - Collection view data source

extension InteractionsViewController: UICollectionViewDataSource {
    
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.current.interactions.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0..<User.current.interactions.count:
            let cell = collectionView.dequeueReusable(cellType: InteractionCollectionViewCell.self, forIndexPath: indexPath)
            let interaction = User.current.interactions[indexPath.row]
            cell.interaction = interaction
            cell.editButtonTappedHandler = { [weak self] in
                self?.displayInteractionViewController(interaction)
            }
            
            cell.shareButtonTappedHandler = { [weak self] in
                self?.displayShareAction(interaction)
            }
            
            return cell
        case User.current.interactions.count:
            return collectionView.dequeueReusable(cellType: AddInteractionCollectionViewCell.self, forIndexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? InteractionCollectionViewCell)?.backgroundImageView.af_cancelImageRequest()
        (cell as? InteractionCollectionViewCell)?.foregroundImageView.af_cancelImageRequest()
    }
}


// MARK: - Collection view delegate

extension InteractionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0..<User.current.interactions.count:
            let interaction = User.current.interactions[indexPath.row]
            interaction.interact()
        case User.current.interactions.count:
            displayInteractionViewController()
        default: break
        }
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
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        guard let _ = collectionView.indexPathsForSelectedItems,
            let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) else {
                return nil
        }
        
        guard indexPath.row != User.current.interactions.count else { return nil }
        
        previewingContext.sourceRect = cell.frame
        let viewController = InteractingViewController()
        viewController.preferredContentSize = CGSize(width: view.frame.size.width - 30, height: view.frame.size.width - 30)
        
        let interaction = User.current.interactions[indexPath.row]
        interaction.interact()
        
        return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {}
}
