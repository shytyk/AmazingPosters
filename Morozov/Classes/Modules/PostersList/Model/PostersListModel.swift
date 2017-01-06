//
//  PostersListModel.swift
//  Morozov
//
//  Created by Mykyta Shytik on 12/17/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit

let imageNames = [
    "m01.png", "m02.png", "m03.png", "m04.png", "m05.png", "m06.png",
    "m07.png", "m08.png", "m09.png", "m10.png", "m11.png", "m12.png"
]

class PostersListModel: NSObject {
    let images: [UIImage] = {
        var result = [UIImage]()
        for name in imageNames {
            result.append(UIImage(named: name)!)
        }
        return result
    }()
    
    let imageTitles = [
        "Basket", "Andy", "Old yard", "Hunter", "Sweet home", "Lavender and apples", "Shaman's dance", "Horse & People", "Pumpkins", "Shoes", "Pumpkins", "Pumpkins"
    ]
    
    func image(at index: Int) -> UIImage {
        return images[index]
    }
    
    func title(at index: Int) -> String {
        return imageTitles[index]
    }
}
