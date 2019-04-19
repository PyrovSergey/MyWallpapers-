//
//  CategoryCollectionViewController.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCollectionViewController: UICollectionViewController, NetworkManagerDelegate {
    
    var nameOfCategory: String?
    private var arrayOfPhotos: [PhotoItem] = []
    private let reuseIdentifier = "PhotosItemCell"
    private let sectionInserts = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 50.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    private var indicator : UIActivityIndicatorView?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = UIActivityIndicatorView(style: .gray)
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
        indicator?.startAnimating()
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        if let category = nameOfCategory {
            navigationItem.title = category
            NetworkManager.getInstance().getRequest(category: category, manager: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            NetworkManager.getInstance().clearCounts()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CustomCollectionViewCell
        let photo: PhotoItem = arrayOfPhotos[indexPath.row]
        cell?.img.sd_setImage(with: URL(string: photo.portrait), completed: nil)
        cell?.layer.cornerRadius = 10
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("current index cell --> \(indexPath.row)")
        if arrayOfPhotos.count - 6 == indexPath.row {
            NetworkManager.getInstance().getRequest(category: nameOfCategory!, manager: self)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(arrayOfPhotos[indexPath.row].photographer)
        performSegue(withIdentifier: "goToSelectImage", sender: arrayOfPhotos[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SelectImageViewController
        destinationVC.selectedPhoto = sender as? PhotoItem
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = self.collectionView.contentOffset.y //self.tableView.contentOffset.y
        for cell in self.collectionView.visibleCells as! [CustomCollectionViewCell] {
            let x = cell.img.frame.origin.x
            let w = cell.img.bounds.width
            let h = cell.img.bounds.height
            let y = ((offsetY - cell.frame.origin.y) / h) * 25
            cell.img.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
}

// MARK: - Collection View Flow Layout Delegate
extension CategoryCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddengSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddengSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    func successRequest(result: [PhotoItem]) {
        indicator?.stopAnimating()
        arrayOfPhotos += result
        collectionView.reloadData()
    }
    
    func errorRequest(errorMessage: String) {
        print("Error request NetworkManagerDelegate in CategoryCollectionViewController ---> \(errorMessage)")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

