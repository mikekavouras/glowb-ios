//
//  InteractionsViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/8/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import AlamofireImage
import AVFoundation
import SnapKit

fileprivate enum SettingsGearState {
    case inactive
    case active
}

class InteractionsViewController: BaseViewController {
    
    // MARK: - Properties
    // MARK: -

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var gearIcon: UIImageView!
    
    fileprivate var settingsViewController: SettingsViewController?
    fileprivate var isDragging = false
    
    fileprivate var gearState: SettingsGearState = .inactive {
        didSet {
            switch self.gearState {
            case .inactive:
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.gearIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    self.gearIcon.alpha = 0.3
                }, completion: nil)
            default:
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.gearIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.gearIcon.alpha = 1.0
                }, completion: nil)
            }
        }
    }
    
    
    // MARK: - Life cycle
    // MARK: -
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    // MARK: - Setup
    // MARK: -
    
    private func setup() {
        setupCollectionView()
        setupForceTouch()
        gearIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        gearIcon.alpha = 0.3
    }
    
    private func setupForceTouch() {
        registerForPreviewing(with: self, sourceView: collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    
        collectionView.register(cellType: AddInteractionCollectionViewCell.self)
        collectionView.register(cellType: InteractionCollectionViewCell.self)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - Navigation
    // MARK: -
    
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
    
    
    // MARK: - Actions
    // MARK: - 
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let viewController = SettingsViewController()
        let navController = BaseNavigationController(rootViewController: viewController)
        present(navController, animated: true, completion: nil)
    }
}


// MARK: - Collection view data source
// MARK: - 

extension InteractionsViewController: UICollectionViewDataSource {
    
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
// MARK: -

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
// MARK: - 

extension InteractionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
}


// MARK: - Previewing context delegate
// MARK: - 

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


// MARK: - Scroll view delegate
// MARK: - 

extension InteractionsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < -80 {
            if gearState == .active { return }
            gearState = .active
            if isDragging {
                SoundLibrary.shared.play(.popIn)
            }
        } else {
            if gearState == .inactive { return }
            gearState = .inactive
            if isDragging {
                SoundLibrary.shared.play(.popOut)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
        
        guard scrollView.contentOffset.x < -80 else { return }
        
        let viewController = SettingsViewController()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = FadeTransitioningDelegate.shared
        navigationController.modalPresentationStyle = .custom
        present(navigationController, animated: true, completion: nil)
    }
}
