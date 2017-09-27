//
//  ViewController.swift
//  FoodTracker
//
//  Created by Ram Yadav on 8/3/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, or Cancelled", log: .default, type: .debug)
            return
        }
        
        let name = textField.text ?? "" //?? used for optional, if value rapped
        //and return original value, if nil return defalut value, in this case emtpy string
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        //set the meal to be passed to MealTableViewController after unwind segue
        meal = Meal(name: name, image: photo, rating: rating)
    }
    
    //MARK: Cancel
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
    let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
          dismiss(animated: true, completion: nil)
        } else if let owiningNavigationController = navigationController {
           owiningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The meal controller is not inside a navigation controller")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.name
            textField.text   = meal.name
            photoImageView.image = meal.image
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //hide the textField
        textField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    //Mark: private method
    private func updateSaveButtonState() {
        let text = textField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

