//
//  PostersListHiddenModel.swift
//  Morozov
//
//  Created by Mykyta Shytik on 12/25/16.
//  Copyright © 2016 Mykyta Shytik. All rights reserved.
//

import UIKit

class PostersListHiddenModel: NSObject {
    let imageNames = [
        "hid02.jpg", "hid01.png", "hid03.jpg", "hid04.png",
        "hid05.png", "hid06.jpg", "hid07.png"
    ]
    
    let imageTitles = [
        "Sherpa", "About a locomotive", "Bubble blower", "Nastya", "Bob", "Деньги. Грошi. Money", "July"
    ]
    
    func image(at index: Int) -> UIImage {
        return UIImage(named: imageNames[index])!
    }
    
    func title(at index: Int) -> String {
        return imageTitles[index]
    }
}
