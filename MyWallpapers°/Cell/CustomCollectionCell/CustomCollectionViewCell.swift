//
//  CustomCollectionViewCell.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgWrapper: UIView!
    
    override func awakeFromNib() {
        self.imgWrapper.clipsToBounds = true
    }
}
