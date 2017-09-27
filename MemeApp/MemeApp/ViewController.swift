//
//  ViewController.swift
//  MemeApp
//
//  Created by Ram Yadav on 8/6/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var mimiOne: UITextField!
    @IBOutlet weak var mimiTwo: UITextField!
    var imagePick: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareIcon = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.leftBarButtonItem = shareIcon
    }
    
    
    func share() {
        if imagePick == nil {
            imagePick = UIImage(named: "Image")
        }
        let imageToshare = [imagePick!]
        let activityController = UIActivityViewController(activityItems: imageToshare, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view //don't crash on ipads
        
        //exclude some options
//        activityController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.postToFacebook]
        present(activityController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Error while selecting the photo")
        }
        imagePickView.image = selectImage
        imagePick = selectImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAlbumImage(_ sender: UIBarButtonItem) {
        let picController = UIImagePickerController()
        picController.delegate = self
        picController.sourceType = .photoLibrary
        present(picController, animated: true, completion: nil)
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
       let takePhoto = UIImagePickerController()
        takePhoto.delegate = self
        takePhoto.sourceType = .camera
    }
    
    @IBAction func cancel(_ sender: Any) {
        mimiOne.text = ""
        mimiTwo.text = ""
        let image = UIImage(named: "Image")
        imagePickView.image = image
    }
}

