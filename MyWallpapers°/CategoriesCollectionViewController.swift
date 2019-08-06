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
    private let categoryArray = DataStorage.share.categoryArray
    private let reuseIdentifier = "CategoriesCell"
}

// MARK: - Override
extension CategoriesCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToSelectCategory" {
            let destinationVC = segue.destination as! CategoryCollectionViewController
            let index = sender as? IndexPath
            destinationVC.nameOfCategory = categoryArray[(index?.row)!]
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
            self.performSegue(withIdentifier: "goToSelectCategory", sender: indexPath)
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
