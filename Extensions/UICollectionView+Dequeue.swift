//
//  UICollectionView+Dequeue.swift
//  MyWallpapers°
//
//  Created by Sergey on 25/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    func dequeueReusableCell<CellType: UICollectionViewCell>(for indexPath: IndexPath) -> CellType? {
        
        let typeName = String(describing: CellType.self)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: typeName, for: indexPath) as? CellType else {
            return nil
        }
        return cell
    }
}
