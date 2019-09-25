//
//  Router.swift
//  MyWallpapers°
//
//  Created by Sergey on 25/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

class Router {
    
    static let shared = Router()
    private var window: UIWindow?
    private var rootNavigationController: UINavigationController!
    private init() {}
}

// MARK: - Public Interface
extension Router {
    
    func openCategories() {
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        let viewController = initialCategoriesCollectionViewController()
        window?.changeRootViewController(to: viewController)
    }
    
    func openCategory(by name: String) {
        let viewController = initialCategoryCollectionViewController()
        viewController.nameOfCategory = name
        rootNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func openSelectedImage(by photo: PhotoItem) {
        let viewController = initialSelectImageViewController()
        viewController.selectedPhoto = photo
        rootNavigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Private
private extension Router {
    
    func initialCategoriesCollectionViewController() -> UIViewController {
        let viewController = CategoriesCollectionViewController.instantinateFromStoryboard()
        rootNavigationController = UINavigationController(rootViewController: viewController)
        return rootNavigationController
    }
    
    func initialCategoryCollectionViewController() -> CategoryCollectionViewController {
        let viewController = CategoryCollectionViewController.instantinateFromStoryboard()
        return viewController
    }
    
    func initialSelectImageViewController() -> SelectImageViewController {
        let viewController = SelectImageViewController.instantinateFromStoryboard()
        return viewController
    }
}


