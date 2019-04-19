//
//  System.swift
//  MyWallpapers°
//
//  Created by Sergey on 19/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//


import UIKit

struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
