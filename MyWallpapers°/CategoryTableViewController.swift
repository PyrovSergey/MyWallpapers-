//
//  ViewController.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoryTableViewController: UITableViewController {
    
    private let categoryArray = DataStorage.getInstance().categoryArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        prepareChangeConnectionListener()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkCurrentConnection()
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let colour = AverageColorFromImage(UIImage(named: categoryArray[indexPath.row])!)
        cell.categoryTitle.textColor = ContrastColorOf(colour, returnFlat: true)
        cell.categoryTitle.text = categoryArray[indexPath.row]
        cell.img.image = UIImage(named: categoryArray[indexPath.row])
        cell.layer.cornerRadius = 30
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = self.tableView.contentOffset.y
        for cell in self.tableView.visibleCells as! [CustomTableViewCell] {
            let x = cell.img.frame.origin.x
            let w = cell.img.bounds.width
            let h = cell.img.bounds.height
            let y = ((offsetY - cell.frame.origin.y) / h) * 25
            cell.img.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkManager.isReachable { _ in
            self.performSegue(withIdentifier: "goToSelectCategory", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryCollectionViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.nameOfCategory = categoryArray[indexPath.row]
        }
    }
    
    private func prepareChangeConnectionListener() {
        NetworkManager.getInstance().reachability.whenUnreachable = {
            _ in
            self.showLostConnectionMessage()
        }
    }
    
    private func checkCurrentConnection() {
        NetworkManager.isUnreachable { _ in
            self.showLostConnectionMessage()
        }
    }
    
    private func showLostConnectionMessage() {
        let dialogMessage = UIAlertController(title: "Lost internet connection", message: "Check connection settings", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { action in
            self.checkCurrentConnection()
        }
        dialogMessage.addAction(okButton)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
}


