//
//  PostersListHiddenController.swift
//  Morozov
//
//  Created by Mykyta Shytik on 12/25/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

private let cellsDistance: CGFloat = 7

typealias PostersListHiddenCallback = (PostersListHiddenController, UIImage, String) -> Void
typealias PostersListHiddenCloseCallback = (PostersListHiddenController) -> Void

class PostersListHiddenController: NSObject {
    fileprivate let model = PostersListHiddenModel()
    fileprivate let collectionView: UICollectionView
    var tapCallback: PostersListHiddenCallback?
    var closeCallback: PostersListHiddenCloseCallback?
    var didClose = false
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
        setupLayout()
    }
    
    private func setupCollectionView() {
        let cellId = "PostersListCell"
        collectionView.register(
            UINib(nibName: cellId, bundle: nil),
            forCellWithReuseIdentifier: cellId
        )
//        collectionView.collectionViewLayout = calculator
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupLayout() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = cellsDistance
        layout.minimumInteritemSpacing = cellsDistance
        layout.headerInset = UIEdgeInsetsMake(20, 0, 0, 0)
        layout.footerInset = UIEdgeInsetsMake(100, 0, 0, 0)
        layout.itemRenderDirection = .leftToRight
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
    }
}

extension PostersListHiddenController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostersListCell", for: indexPath) as! PostersListCell
        cell.posterImageView.image = model.image(at: indexPath.row)
        return cell
    }
}

extension PostersListHiddenController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.row
        tapCallback?(self, model.image(at: idx), model.title(at: idx))
    }
}

extension PostersListHiddenController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !didClose {
            didClose = true
            closeCallback?(self)
        }
    }
}

extension PostersListHiddenController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let imageSize = model.image(at: indexPath.row).size
        return imageSize
    }
}
