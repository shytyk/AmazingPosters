//
//  PosterView.swift
//  Morozov
//
//  Created by Mykyta Shytik on 12/17/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit

class PosterView: UIView {
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var posterLabel: UILabel!
    
    static func fromNib() -> PosterView {
        let objs = Bundle.main.loadNibNamed("PosterView", owner: nil, options: nil)
        return objs?.first as! PosterView
    }
    
    @IBAction func removeTap() {
        UIView.animate(
            withDuration: 0.45,
            animations: { 
                self.alpha = 0
            },
            completion: { completed in
                self.removeFromSuperview()
            }
        )
    }
}
