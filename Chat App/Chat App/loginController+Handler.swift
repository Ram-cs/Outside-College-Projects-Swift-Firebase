//
//  loginController+Handler.swift
//  Chat App
//
//  Created by Ram Yadav on 8/11/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString //generate unique string
            let storageReference = Storage.storage().reference().child("Profile_image").child("\(imageName).png")
           
            //can use here JPEG for compress image like for fast performance
           // let upload = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1)
            if let profileImage = self.profileImageView.image, let uploadData = UIImagePNGRepresentation(profileImage) {
                
            
//            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) { // shouldn't usse this if
                //statement for better code writing

                storageReference.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        fatalError("error uploading custome image: \(error!)")
                    } else {
                        if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                            let value = ["Name": name, "Email": email, "Password": password, "ProfileImage": profileImageURL] as [String : Any]
                            self.registerUserIntoDatabasewithUID(uid: uid, values: value as [String : AnyObject])
                        }
                    }
                })
            }
        })
    }

    func registerUserIntoDatabasewithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            let user = User()
            //this setter potentially crashed if don't mathce the name is User()
            user.setValuesForKeys(values)
            self.messangerController?.setNavBarWithUser(user: user)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    //trigger this function to pic the image
    func handleSelectProfileImageView() {
       let picker = UIImagePickerController() 
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var profileImage: UIImage?
        
        if let selectedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImage = selectedImage
        } else if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage = selectedImage
        }   
        
        if (profileImage != nil) {
            profileImageView.image = profileImage
        }
        dismiss(animated: true, completion: nil)
    }
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
