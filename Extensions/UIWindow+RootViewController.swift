//
//  UIWindow+RootViewController.swift
//  MyWallpapers°
//
//  Created by Sergey on 25/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func changeRootViewController(to viewController: UIViewController) {
        
        guard rootViewController != nil else {
            rootViewController = viewController
            makeKeyAndVisible()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window = self
            }
            return
        }
        
        UIView.transition(with: self,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.rootViewController = viewController
        }, completion: nil)
    }
}
