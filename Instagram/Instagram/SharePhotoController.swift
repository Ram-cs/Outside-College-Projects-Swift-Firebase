//
//  SharedPhotoController.swift
//  Instagram
//
//  Created by Ram Yadav on 9/14/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoControler: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
           self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setUpImageAndTextView()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true //to fit image within the view
        iv.backgroundColor = UIColor.white
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 5
        tv.clipsToBounds = true
        tv.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return tv
    }()
    
    fileprivate func setUpImageAndTextView() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(textView)
        //view.topanchor wouldn't work, so toplayoutGuid.bottomanchor should use
        containerView.anchor(left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, top: topLayoutGuide.bottomAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: 0, height: 100)
        
        imageView.anchor(left: containerView.leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, top: containerView.topAnchor, topPadding: 8, bottom: containerView.bottomAnchor, bottomPadding: -8, width: 84, height: 0)
        
        textView.anchor(left: imageView.rightAnchor, leftPadding: 8, right: containerView.rightAnchor, rightPadding: -8, top: containerView.topAnchor, topPadding: 8, bottom: containerView.bottomAnchor, bottomPadding: -8, width: 0, height: 0)
    }
    
    func handleShare() {
        guard let caption = textView.text, caption.characters.count > 0 else {return}
        guard let image = selectedImage else {return}
        guard let uploadData = UIImageJPEGRepresentation(image, 0.8) else {return}
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("posts").child(fileName)
        ref.putData(uploadData, metadata: nil) { (metadata, error) in
            if let err = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Error uploading post image: ", err)
                return
            }
            print("Succefull loading post image")
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
        
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
        }
    }
    
    static var updateFeedNotificationName = "notificationName"
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else {return}
        guard let caption = textView.text else {return}
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["imageURL": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, reference) in
            if let error = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Error to Uploading post's image url to DB", error)
                return
            }
            print("Succefully uploaded ImageURL to the DB")
            self.dismiss(animated: true, completion: nil)
            
            //atomatically call refresh when add post, to make it works, called on HomeController
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SharePhotoControler.updateFeedNotificationName), object: nil)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
