//
//  PostersListCell.swift
//  Morozov
//
//  Created by Mykyta Shytik on 12/17/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit

class PostersListCell: UICollectionViewCell {

    @IBOutlet var posterImageView: UIImageView!
    
    override var isHighlighted: Bool {
        set {
            if newValue != isHighlighted {
                super.isHighlighted = newValue
                let result = CGFloat(isHighlighted ? 0.93 : 1.0)
                UIView.animate(withDuration: 0.14) {
                    self.layer.transform = CATransform3DMakeScale(
                        result,
                        result,
                        1
                    )
                }
            }
        }
        
        get {
            return super.isHighlighted
        }
    }

}
