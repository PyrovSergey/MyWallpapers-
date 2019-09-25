//
//  CategoryCollectionViewController.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCollectionViewController: UICollectionViewController {
    
    var nameOfCategory: String?
    
    private var arrayOfPhotos: [PhotoItem] = []
    private let reuseIdentifier = "PhotosItemCell"
    private let sectionInserts = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 50.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    private var indicator : UIActivityIndicatorView?
}

// MARK: - Override
extension CategoryCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            NetworkManager.share.clearCounts()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Private
private extension CategoryCollectionViewController {
    
    func setupView() {
        indicator = UIActivityIndicatorView(style: .gray)
        indicator?.center = view.center
        view.addSubview(indicator!)
        indicator?.startAnimating()
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        guard let category = nameOfCategory else { return }
        
        navigationItem.title = category
        NetworkManager.share.getRequest(category: category, manager: self)
    }
}

// MARK: - NetworkManagerDelegate
extension CategoryCollectionViewController: NetworkManagerDelegate {
    
    func successRequest(result: [PhotoItem]) {
        indicator?.stopAnimating()
        arrayOfPhotos += result
        collectionView.reloadData()
    }
    
    func errorRequest(errorMessage: String) {
        print("Error request NetworkManagerDelegate in CategoryCollectionViewController ---> \(errorMessage)")
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
}

// MARK: - UICollectionViewDelegate
extension CategoryCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if arrayOfPhotos.count - 6 == indexPath.row {
            NetworkManager.share.getRequest(category: nameOfCategory!, manager: self)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.shared.openSelectedImage(by: arrayOfPhotos[indexPath.row])
    }
}

// MARK: - UIScrollViewDelegate
extension CategoryCollectionViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = collectionView.contentOffset.y
        for cell in collectionView.visibleCells as! [CustomCollectionViewCell] {
            let x = cell.img.frame.origin.x
            let w = cell.img.bounds.width
            let h = cell.img.bounds.height
            let y = ((offsetY - cell.frame.origin.y) / h) * 25
            cell.img.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
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
}

// MARK: - StoryboardInstantinable
extension CategoryCollectionViewController: StoryboardInstantinable {}

