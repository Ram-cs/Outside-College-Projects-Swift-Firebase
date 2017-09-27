//
//  ViewController.swift
//  Instagram
//
//  Created by Ram Yadav on 9/9/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let photoButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
        return button
    }()
    
    func handlePhotoButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //.wighRenderingMOde(.alwaysOriginal) must put to render image
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            photoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            photoButton.layer.cornerRadius = photoButton.frame.width / 2
            photoButton.clipsToBounds = true
            photoButton.layer.borderColor = UIColor.rgb(red: 149, green: 204, blue: 244).cgColor
            photoButton.layer.borderWidth = 5
        
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
             photoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            photoButton.layer.cornerRadius = photoButton.frame.width / 2
            photoButton.clipsToBounds = true
            photoButton.layer.borderColor = UIColor.rgb(red: 149, green: 204, blue: 244).cgColor
            photoButton.layer.borderWidth = 5
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    //When filled all input, heightlight the signUp button
    func handleTextInputChange() {
        let istextValid = emailTextField.text?.characters.count ?? 0 > 0 &&
                          passwordTextField.text?.characters.count ?? 0 > 0 &&
                          userNameTextField.text?.characters.count ?? 0 > 0
        
        if istextValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    func handleSignUp() {
        //get email and should not be empty
        guard let email = emailTextField.text, email.characters.count > 0 else {return}
        guard let password = passwordTextField.text, password.characters.count > 0 else {return}
        guard let userName = userNameTextField.text, userName.characters.count > 0 else {return}
       
        //store the user INFO into the dataBase AUTH
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Problem with creating Account", err)
                return
            }
            print("User succefully created")
            
        //store the profile picture in the database Storage
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Profile_image")
        guard let profileImage = self.photoButton.imageView?.image else {return }
        guard let uploadImage = UIImageJPEGRepresentation(profileImage, 0.3) else {return}
        
            //to upload image first MUST CREATE USER
        storageRef.child(fileName).putData(uploadImage, metadata: nil) { (metadata, error) in
            if let err = error {
                print("Failed uploading profile image: ", err)
                return
            }
            
            guard let profileUrl = metadata?.downloadURL()?.absoluteString else {return}
            print("Image succefully uploaded into db:", profileUrl)
            
                guard let uid = user?.uid else {return }
                let ref = Database.database().reference().child("users").child(uid)
                let dictionary = ["Email": email, "Password": password, "UserName": userName, "ProfileURL": profileUrl]
                ref.updateChildValues(dictionary, withCompletionBlock: { (error, ref) in
                    if let err = error {
                        print("Problem saving user's data", err)
                        return
                    }
                    print("User saved in the database")
                    
                    //to refresh user, must get reference of the rootview, and
                    //this is how get the reference of rootViewController
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    
                    mainTabBarController.setUpViewController()
                    
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In.", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAnAccount), for: .touchUpInside)
        return button
    }()
    
    func handleAlreadyHaveAnAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(photoButton)
        view.addSubview(alreadyHaveAnAccountButton)
        
        //ios constrains
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoButton.anchor(left: nil, leftPadding: 0, right: nil, rightPadding: 0, top: view.topAnchor, topPadding: 40, bottom: nil, bottomPadding: 0, width: 140, height: 140)
        
        alreadyHaveAnAccountButton.anchor(left: view.leftAnchor, leftPadding: 12, right: view.rightAnchor, rightPadding: 12, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -12, width: 0, height: 40)
        
        setUpInputField()
    }
    
    fileprivate func setUpInputField() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually //must put it to show other subview in stackView
        stackView.backgroundColor = UIColor.green
        stackView.axis = .vertical
        stackView.spacing = 10
    
        view.addSubview(stackView)

        stackView.anchor(left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: -40, top: photoButton.bottomAnchor, topPadding: 40, bottom: nil, bottomPadding: 0, width: 0, height: 160)
    }
    
}



















