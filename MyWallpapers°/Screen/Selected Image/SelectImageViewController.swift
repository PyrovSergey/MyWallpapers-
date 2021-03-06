//
//  SelectImageViewController.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit
import SDWebImage

class SelectImageViewController: UIViewController {
    
    @IBOutlet private weak var photoView: UIImageView!
    var selectedPhoto: PhotoItem?
}

// MARK: - Override
extension SelectImageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Action
private extension SelectImageViewController {
    
    @objc func action() {
        let vc = UIActivityViewController(activityItems: [photoView.image!], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @objc  func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imageView = tapGestureRecognizer.view as! UIImageView
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photoView.addGestureRecognizer(tapGestureRecognizer)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func save() {
        guard let selectedImage = photoView.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
}

// MARK: - Private
private extension SelectImageViewController {
    
    func setupView() {
        photoView.sd_setImage(with: URL(string: selectedPhoto!.portrait), completed: nil)
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(action))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItems = [actionButton, saveButton]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photoView.isUserInteractionEnabled = true
        photoView.addGestureRecognizer(tapGestureRecognizer)
    }

    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

// MARK: - StoryboardInstantinable
extension SelectImageViewController: StoryboardInstantinable {}

