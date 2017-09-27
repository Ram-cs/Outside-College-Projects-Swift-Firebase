//
//  ViewController.swift
//  RateFood
//
//  Created by Ram Yadav on 8/2/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        textField.delegate = self
        super.viewDidLoad()
    }
    


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        label.text = textField.text
    }

    @IBAction func submit(_ sender: Any) {
        label.text = textField.text;
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyborad while selecting the photo
        textField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Dictionary should contain email, but givign the follwing error\(info)")
        }
        
        imageView.image = imagePicked
        dismiss(animated: true, completion: nil)
    }
    

}



























































