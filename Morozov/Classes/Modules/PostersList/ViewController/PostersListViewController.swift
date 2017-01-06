//
//  PostersListViewController.swift
//  Morozov
//
//  Created by Mykyta Shytik on 12/16/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import pop

private let headerHeight: CGFloat = 125
private let headerHeightX8: CGFloat = headerHeight * 8
private let headerHeightX7d5: CGFloat = headerHeight * 7.5
private let headerLabelHeight: CGFloat = 46
private let cellsDistance: CGFloat = 11
private let cellID = "PostersListCell"
private let topConstraintConstant: CGFloat = 20
private let subtitleConstraintConstant: CGFloat = 70
private let titleConstraintConstant: CGFloat = 24
private let titleConstraintOffset: CGFloat = 400

class PostersListViewController: UIViewController {
    
    @IBOutlet fileprivate var topConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var subtitleTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var topLabel: UILabel!
    @IBOutlet fileprivate var subtitleLabel: UILabel!
    @IBOutlet fileprivate var collectionView: UICollectionView!
    @IBOutlet fileprivate var hiddenCollectionView: UICollectionView!
    @IBOutlet fileprivate var contactButton: UIButton!
    @IBOutlet fileprivate var contactBottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var leftTitleConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var rightTitleConstraint: NSLayoutConstraint!
    
    fileprivate var isPerformingHiddenAnimation = false
    fileprivate var hiddenController: PostersListHiddenController!
    
    let model = PostersListModel()
    var shouldHideCells = true
    var showsContacts = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupCollection()
        view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.animateLabelConstraint()
            self.shouldHideCells = false
        }
        
    }
    
    @IBAction func contactTap() {
        let url = URL(string: "https://www.behance.net/mr_lucky")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

// MARK: - Initial animations
fileprivate extension PostersListViewController {
    func setupConstraints() {
        topConstraint.constant = (UIScreen.main.bounds.height - headerLabelHeight) / 2
        subtitleTopConstraint.constant = 100
        subtitleLabel.alpha = 0
    }
    
    func animateLabelConstraint() {
        topConstraint.constant = topConstraintConstant
        view.setNeedsUpdateConstraints()
        UIView.animate(
            withDuration: 0.85,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                self.showSubtitleLabel()
            }
        )
    }
    
    func showSubtitleLabel() {
        subtitleTopConstraint.constant = subtitleConstraintConstant
        view.setNeedsUpdateConstraints()
        UIView.animate(
            withDuration: 0.35,
            animations: {
                self.view.layoutIfNeeded()
                self.subtitleLabel.alpha = 1
            },
            completion: { completed in
                self.animateCollectionIn()
                self.view.isUserInteractionEnabled = true
            }
        )
    }
}

// MARK: - Private/misc
fileprivate extension PostersListViewController {
    func show(image: UIImage, title: String) {
        let posterView = PosterView.fromNib()
        posterView.frame = UIScreen.main.bounds
        posterView.alpha = 0
        posterView.posterImageView.image = image
        posterView.posterLabel.text = title
        view.window?.addSubview(posterView)
        UIView.animate(withDuration: 0.45) {
            posterView.alpha = 1
        }
    }
}

// MARK: - Collection View
fileprivate extension PostersListViewController {
    func setupCollection() {
        setupCollectionDelegates()
        setupLayout()
        registerCells()
        
        collectionView.alpha = 0
        collectionView.reloadData()
        for cell in collectionView.visibleCells {
            cell.alpha = 0
        }
        collectionView.alpha = 1
        
        hiddenCollectionView.alpha = 0
        hiddenController = PostersListHiddenController(collectionView: hiddenCollectionView)
        hiddenController.tapCallback = { [weak self] _, image, name in
            self?.show(image: image, title: name)
        }
        hiddenController.closeCallback = { [weak self] _ in
            self?.returnAnimation()
        }
    }
    
    func registerCells() {
        collectionView.register(
            UINib(nibName: cellID, bundle: nil),
            forCellWithReuseIdentifier: cellID
        )
    }
    
    func setupCollectionDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupLayout() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = cellsDistance
        layout.minimumInteritemSpacing = cellsDistance
        layout.headerInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0)
        layout.footerInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0)
        layout.itemRenderDirection = .shortestFirst
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
    }
    
    func animateCollectionIn() {
        for (idx, cell) in collectionView.visibleCells.enumerated() {
            cell.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(idx) * 0.15) {
                UIView.animate(withDuration: 0.25) {
                    cell.alpha = 1
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PostersListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PostersListCell
        cell.posterImageView.image = model.image(at: indexPath.row)
        cell.alpha = shouldHideCells ? 0 : 1
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PostersListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = model.image(at: indexPath.row)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.show(image: image, title: self.model.title(at: indexPath.row))
        }
    }
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout
extension PostersListViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let imageSize = model.image(at: indexPath.row).size
        return imageSize
    }
}

// MARK: - UIScrollViewDelegate
extension PostersListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        checkContacts(y: y)
        
        if y > 300 {
            return
        }
        
        if y <= -125 && !isPerformingHiddenAnimation {
            isPerformingHiddenAnimation = true
            updateAnimation()
        }
        
        var topResult = topConstraintConstant - (y < 0 ? (y / 2) : y)
        var subtitleResult = subtitleConstraintConstant - y
        let offset: CGFloat = -100
        if topResult < offset {
            topResult = offset
        }
        if subtitleResult < offset {
            subtitleResult = offset
        }
        topConstraint.constant = topResult
        subtitleTopConstraint.constant = subtitleResult
    }
    
    func updateAnimation() {
        collectionView.pop_removeAnimation(forKey: "anim")
        
        let animation = POPBasicAnimation.linear()!
        animation.property = POPAnimatableProperty.property(withName: kPOPCollectionViewContentOffset) as! POPAnimatableProperty
        animation.fromValue = NSValue(cgPoint: collectionView.contentOffset)
        let toPoint = CGPoint(x: 0, y: -UIScreen.main.bounds.height + 125)
        animation.toValue = NSValue(cgPoint: toPoint)
        
        animation.duration = 0.4
        animation.completionBlock = { [weak self] _, completed in
            self?.onUpdateAnimation()
        }
        collectionView.pop_add(animation, forKey: "anim")
        
        collectionView.isUserInteractionEnabled = false
        collectionView.panGestureRecognizer.isEnabled = false
        collectionView.panGestureRecognizer.isEnabled = true
    }
    
    func returnAnimation() {
        startOutAnimation { [weak self] in
            self?.performOut()
        }
    }
    
    func onUpdateAnimation() {
        leftTitleConstraint.constant = titleConstraintConstant - titleConstraintOffset
        rightTitleConstraint.constant = titleConstraintConstant + titleConstraintOffset
        view.setNeedsUpdateConstraints()
        UIView.animate(
            withDuration: 0.55,
            animations: { 
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                for cell in self.hiddenCollectionView.visibleCells {
                    cell.alpha = 0
                }
                self.hiddenCollectionView.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    for (idx, cell) in self.hiddenCollectionView.visibleCells.enumerated() {
                        UIView.animate(
                            withDuration: 0.15,
                            delay: Double(idx) * 0.08,
                            options: .beginFromCurrentState,
                            animations: {
                                cell.alpha = 1
                            },
                            completion: nil
                        )
                    }
                })
            }
        )
    }
    
    func startOutAnimation(completion: ((Void) -> Void)?) {
        view.isUserInteractionEnabled = false
        for (idx, cell) in self.hiddenCollectionView.visibleCells.enumerated() {
            UIView.animate(
                withDuration: 0.12,
                delay: Double(idx) * 0.06,
                options: .beginFromCurrentState,
                animations: {
                    cell.alpha = 0
                },
                completion: nil
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.leftTitleConstraint.constant = titleConstraintConstant
            self.rightTitleConstraint.constant = titleConstraintConstant
            self.view.setNeedsUpdateConstraints()
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.view.layoutIfNeeded()
                },
                completion: { completed in
                    completion?()
                }
            )
        }
    }
    
    func performOut() {
        hiddenCollectionView.alpha = 0
        collectionView.pop_removeAnimation(forKey: "anim")
        collectionView.isUserInteractionEnabled = false
        
        let animation = POPBasicAnimation.linear()!
        animation.property = POPAnimatableProperty.property(withName: kPOPCollectionViewContentOffset) as! POPAnimatableProperty
        animation.fromValue = NSValue(cgPoint: collectionView.contentOffset)
        let toPoint = CGPoint(x: 0, y: 0)
        animation.toValue = NSValue(cgPoint: toPoint)
        
        animation.duration = 0.4
        animation.completionBlock = { [weak self] _, completed in
            self?.collectionView.isUserInteractionEnabled = true
            self?.isPerformingHiddenAnimation = false
            self?.hiddenController.didClose = false
            self?.view.isUserInteractionEnabled = true
        }
        collectionView.pop_add(animation, forKey: "anim")
    }
    
    func checkContacts(y: CGFloat) {
        let content = collectionView.contentSize.height
        if !showsContacts && (y > content - headerHeightX8) {
            showsContacts = true
            animateContacts(shows: true)
        } else if showsContacts && (y < content - headerHeightX7d5) {
            showsContacts = false
            animateContacts(shows: false)
        }
    }
    
    func animateContacts(shows: Bool) {
        UIView.animate(
            withDuration: 0.25,
            delay: 0.0,
            options: .beginFromCurrentState,
            animations: {
                self.contactButton.alpha = shows ? 1 : 0
            },
            completion: nil
        )
    }
}
