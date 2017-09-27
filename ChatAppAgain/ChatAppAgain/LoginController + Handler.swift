//
//  loginController + Handler.swift
//  ChatAppAgain
//
//  Created by Ram Yadav on 8/28/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleRegister() {
        guard let email = emailTextField.text, let name = nameTextField.text, let password = passwordTextField.text else {
            print("Form is invalid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if err != nil {
                print(err!)
                return
            }
            
            guard let userId = user?.uid else {
                print("Error creating account")
                return
            }
            
            if let getImage = self.setProfileImage.image, let data = UIImageJPEGRepresentation(getImage, 0.1) { //using jpeg to compreee the image for fast
                let imageName = NSUUID().uuidString //generate unique string
                
                let storageRef = Storage.storage().reference().child("Profileimage.jpeg").child("\(imageName).png")
                storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                    }
                if let imageURL = metadata?.downloadURL()?.absoluteString {
                    let values = ["Name": name, "Email": email, "Password": password, "ImageURL": imageURL] as [String : Any]
                    self.registerUserInDatabaseWithUID(userId: userId, value: values)
                    }
                })
            }
        }
        
    }
    
    private func registerUserInDatabaseWithUID(userId: String, value: [String: Any]) {
            let reference = Database.database().reference().child("users")
            reference.child(userId).updateChildValues(value) { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
        }
        let user = User()
        user.setValuesForKeys(value)
        self.messageController?.setUpNavBarWithUser(user: user)
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImage: UIImage?
        
        if let chooseImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            pickedImage = chooseImage
        } else if let chooseImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            pickedImage = chooseImage
        }
        
        if let selectedImage = pickedImage {
            setProfileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}




















