//
//  CategoryCollectionViewCell.swift
//  MyWallpapers°
//
//  Created by Sergey on 19/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoriesCollectionViewController: UICollectionViewController {
    private var categoryArray: [String] = []
    private let reuseIdentifier = "CategoriesCell"
}

// MARK: - Override
extension CategoriesCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        categoryArray = readCategoriesFromFile()
        prepareChangeConnectionListener()
        collectionView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCurrentConnection()
        
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CustomCategoriesViewCell
        let colour = AverageColorFromImage(UIImage(named: categoryArray[indexPath.row])!)
        cell?.categoryTitle.textColor = ContrastColorOf(colour, returnFlat: true)
        cell?.categoryTitle.text = categoryArray[indexPath.row]
        cell?.img.image = UIImage(named: categoryArray[indexPath.row])
        cell?.layer.cornerRadius = 20
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkManager.isReachable { _ in
            Router.shared.openCategory(by: self.categoryArray[indexPath.row])
        }
    }
}

// MARK: - UIScrollViewDelegate
extension CategoriesCollectionViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = self.collectionView.contentOffset.y
        for cell in self.collectionView.visibleCells as! [CustomCategoriesViewCell] {
            let x = cell.img.frame.origin.x
            let w = cell.img.bounds.width
            let h = cell.img.bounds.height
            let y = ((offsetY - cell.frame.origin.y) / h) * 25
            cell.img.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth - 20, height: 130)
    }
}

// MARK: - Private
private extension CategoriesCollectionViewController {
    
    func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Categories"
    }
    
    func readCategoriesFromFile() -> [String] {
        let url = Bundle.main.url(forResource: "Store", withExtension: "plist")!
        let categoriesData = try! Data(contentsOf: url)
        let categoriesList = try! PropertyListSerialization.propertyList(from: categoriesData, options: [], format: nil) as! [String]
        return categoriesList
    }
    
    func prepareChangeConnectionListener() {
        NetworkManager.share.reachability.whenUnreachable = {
            _ in
            self.showLostConnectionMessage()
        }
    }
    
    func checkCurrentConnection() {
        NetworkManager.isUnreachable { _ in
            self.showLostConnectionMessage()
        }
    }
    
    func showLostConnectionMessage() {
        let dialogMessage = UIAlertController(title: "Lost internet connection", message: "Check connection settings", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { action in
            self.checkCurrentConnection()
        }
        dialogMessage.addAction(okButton)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

// MARK: - StoryboardInstantinable
extension CategoriesCollectionViewController: StoryboardInstantinable {}
