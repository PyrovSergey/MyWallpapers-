//
//  CustomTableViewCell.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

class CustomCategoriesViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgWrapper: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        self.imgWrapper.clipsToBounds = true
    }
}
